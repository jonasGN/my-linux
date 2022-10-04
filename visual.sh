#!/bin/bash

# GNOME VERSION TESTED = 42

# SETUP
ALERT_COLOR="\e[31m"
SUCCESS_COLOR="\e[32m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

LOCAL_PATH=$(pwd)
TEMP_WORK_DIR=~/my_linux_temp

print_header() {
  echo -e "${HEADER_COLOR}${1}:${RESET_COLOR}"
}

print_alert() {
  echo -e "${ALERT_COLOR}${1}${RESET_COLOR}"
}

print_success() {
  echo -e "${SUCCESS_COLOR}${1}${RESET_COLOR}"
}

install_extension_dependencies() {
  local DEPENDENCIES=("$@")

  if [[ $(echo "${#DEPENDENCIES[@]}") -gt 0 ]]; then
    print_header "Instalando dependências da extensão"
    sudo apt install -y ${DEPENDENCIES[*]}
  fi
}

# GNOME EXTENSIONS
install_extension() {
  local NAME="$1"
  local URL="$2"

  local WORK_DIR="$TEMP_WORK_DIR/extensions"
  local EXTENSION="$WORK_DIR/$NAME.zip"

  print_header "Fazendo o download da extensão $NAME"
  curl -L --create-dirs --output $EXTENSION --url $URL

  print_header "Instalando extensão"
  local UUID=$(unzip -c $EXTENSION metadata.json | grep uuid | cut -d \" -f4)
  gnome-extensions install "$EXTENSION" && gnome-extensions enable "$UUID"
  print_success "Extensão instalada com sucesso.\n"
}

for ROW in $(cat "$LOCAL_PATH/src/extensions.json" | jq -r '.[] | @base64'); do
  _EXTENSION() {
    echo ${ROW} | base64 --decode | jq -r ${1}
  }

  _EXTENSION_NAME=$(_EXTENSION '.name')
  _EXTENSION_URL=$(_EXTENSION '.url')
  _EXTENSION_VERSION=$(_EXTENSION '.version')
  _EXTENSION_GNOME_VERSION=$(_EXTENSION '.gnome_version')
  _EXTENSION_DEPENDENCIES+=($(_EXTENSION '.dependencies[]'))

  _EXTENSION_FULLNAME="${_EXTENSION_NAME}_gnome${_EXTENSION_GNOME_VERSION}_v${_EXTENSION_VERSION}"

  echo -e "name: $_EXTENSION_NAME\nversion: $_EXTENSION_VERSION\ndependencies: $_EXTENSION_DEPENDENCIES\n"

  install_extension_dependencies "${_EXTENSION_DEPENDENCIES[@]}"
  install_extension "$_EXTENSION_FULLNAME" "$_EXTENSION_URL"
done

# THEME CONFIGURATIONS
echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
read -t 10 -r SELECTED_GNOME_THEME
# default theme is `fluent`
SELECTED_GNOME_THEME="${SELECTED_GNOME_THEME:-fluent}"

mkdir -p "$TEMP_WORK_DIR/themes"
# if user press 'enter' proceed to default theme installation
if [[ "$SELECTED_GNOME_THEME" != "" ]]; then
  while [[ ! "$SELECTED_GNOME_THEME" =~ ^([fluent orchis]) ]]; do
    print_alert "Não foi possível encontrar o tema informado."
    echo -en "Escolha entre: fluent | orchis: "
    read -r SELECTED_GNOME_THEME
  done
elif [[ "$SELECTED_GNOME_THEME" == "" ]]; then
  print_header "\nProsseguindo com tema padrão: ($SELECTED_GNOME_THEME)"
fi

download_repo() {
  local REPO="$1"
  echo "Fazendo o download do repositório"
  git clone $REPO
}

# enable given theme from legacy apps theme and user themes
set_theme() {
  local THEME="$1"
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
  gsettings set org.gnome.shell.extensions.user-theme name "$THEME"
}

# enable given icon theme
set_icon_theme() {
  local ICON_THEME="$1"
  gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
}

# enable cursor given theme
set_cursor_theme() {
  local CURSOR_THEME="$1"
  gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
}

# TODO: install background of themes
# install fluent GTK theme
install_fluent_theme() {
  print_header "Instalando tema Fluent"
  cd "$TEMP_WORK_DIR/themes/Fluent-gtk-theme"
  bash install.sh -t purple -s standard -i debian --tweaks round
  set_theme "Fluent-round-purple-Dark"
}

# install orchis GTK theme
install_orchis_theme() {
  print_header "Instalando tema Orchis"
  cd "$TEMP_WORK_DIR/themes/Orchis-theme"
  bash install.sh -t purple -s standard --tweaks compact
  set_theme "Orchis-Purple-Dark"
}

cd "$TEMP_WORK_DIR/themes"
case "$SELECTED_GNOME_THEME" in
fluent)
  download_repo https://github.com/vinceliuice/Fluent-gtk-theme.git
  install_fluent_theme
  ;;
orchis)
  download_repo https://github.com/vinceliuice/Orchis-theme.git
  install_orchis_theme
  ;;
esac

# ICON CONFIG
mkdir -p "$TEMP_WORK_DIR/icons"

install_fluent_icons() {
  print_header "Instalando tema de ícones Fluent"
  cd "$TEMP_WORK_DIR/icons/Fluent-icon-theme"
  bash install.sh -r standard purple
  set_icon_theme "Fluent-purple-dark"
}

install_tela_icons() {
  print_header "Instalando tema de ícones Tela"
  cd "$TEMP_WORK_DIR/icons/Tela-icon-theme"
  bash install.sh standard purple
  set_icon_theme "Tela-purple-dark"
}

cd "$TEMP_WORK_DIR/icons"
case "$SELECTED_GNOME_THEME" in
fluent)
  download_repo https://github.com/vinceliuice/Fluent-icon-theme.git
  install_fluent_icons
  ;;
orchis)
  download_repo https://github.com/vinceliuice/Tela-icon-theme.git
  install_tela_icons
  ;;
esac

# CURSOR THEME INSTALLATION
print_header "Instalando tema de cursor WhiteSur"
mkdir -p "$TEMP_WORK_DIR/cursor_themes"
cd "$TEMP_WORK_DIR/cursor_themes"

download_repo "https://github.com/vinceliuice/WhiteSur-cursors.git"
cd "$TEMP_WORK_DIR/cursor_themes/WhiteSur-cursors"

bash install.sh
set_cursor_theme "WhiteSur-cursors"

# SETTING VISUAL CONFIGS
print_header "Carregando configurações das extensões..."
dconf load /org/gnome/shell/extensions/ <"$LOCAL_PATH/src/extension-settings.dconf"
# to load all uncomment this line (needs the dconf file)
# dconf load / <./src/all-dconf-settings.dconf

# SETTING OTHER VISUAL CONFIGS
# show weekday on top bar clock
gsettings set org.gnome.desktop.interface clock-show-weekday true
# add minimize and maximize buttons to window top bar
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
# center new windows
gsettings set org.gnome.mutter center-new-windows true

# CLEAN VISUAL FILES
cd "$LOCAL_PATH"
print_success "Configurações visuais aplicadas com sucesso.\nLimpando cache de instalação..."
sudo rm -r "$TEMP_WORK_DIR"

# clean packages and reboot system
REBOOT_TIME=5
sudo apt autoclean && sudo apt autoremove -y
print_header "O sistema será reiniciado em $REBOOT_TIME segundos"
sleep $REBOOT_TIME
sudo reboot

# # SOURCES
# source src/setup.sh
# source src/beutify.sh
# source src/visual/extensions.sh
# source src/visual/themes.sh
# source src/visual/icons.sh
# source src/visual/cursors.sh
# source src/visual/others.sh

# echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
# read -t 10 -r SELECTED_GNOME_THEME

# # default theme is `fluent`
# SELECTED_GNOME_THEME="${SELECTED_GNOME_THEME:-fluent}"

# # if user press 'enter' proceed to default theme installation
# if [[ "$SELECTED_GNOME_THEME" != "" ]]; then
#   while [[ ! "$SELECTED_GNOME_THEME" =~ ^([fluent orchis]) ]]; do
#     print_alert "Não foi possível encontrar o tema informado."
#     echo -en "Escolha entre: fluent | orchis: "
#     read -r SELECTED_GNOME_THEME
#   done
# elif [[ "$SELECTED_GNOME_THEME" == "" ]]; then
#   print_header "\nProsseguindo com tema padrão: ($SELECTED_GNOME_THEME)"
# fi

# # CLEAN VISUAL CACHE FILES
# print_success "Configurações visuais aplicadas com sucesso.\nLimpando cache de instalação..."
# sudo rm -r "$WORK_DIR"

# # clean packages and reboot system
# REBOOT_TIME=5
# sudo apt autoclean && sudo apt autoremove -y
# print_header "O sistema será reiniciado em $REBOOT_TIME segundos"
# sleep $REBOOT_TIME
# sudo reboot
