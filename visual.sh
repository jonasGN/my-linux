#!/bin/bash

# GNOME VERSION TESTED = 42

# SETUP
ALERT_COLOR="\e[31m"
SUCCESS_COLOR="\e[32m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

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

# GNOME EXTENSIONS
install_extension() {
  # sudo mkdir -p $TEMP_WORK_DIR/extensions
  local EXTENSIONS_WORK_DIR=$TEMP_WORK_DIR/extensions
  local EXTENSION_NAME=$1
  local EXTENSION_URL=$2
  local EXTENSION=$EXTENSIONS_WORK_DIR/$EXTENSION_NAME.zip

  print_header "Fazendo o download da extensão: $EXTENSION_NAME"
  curl -L --create-dirs --output $EXTENSION --url $EXTENSION_URL

  local EXTENSION_UUID=$(unzip -c $EXTENSION metadata.json | grep uuid | cut -d \" -f4)
  local GNOME_SHELL_EXTENSIONS_PATH=~/.local/share/gnome-shell/extensions

  mkdir -p $GNOME_SHELL_EXTENSIONS_PATH/$EXTENSION_UUID
  unzip -q $EXTENSION -d $GNOME_SHELL_EXTENSIONS_PATH/$EXTENSION_UUID
  gnome-shell-extension-tool -e $EXTENSION_UUID
}

for ROW in $(cat ./src/extensions.json | jq -r '.[] | @base64'); do
  _EXTENSION() {
    echo ${ROW} | base64 --decode | jq -r ${1}
  }

  _EXTENSION_NAME=$(_EXTENSION '.name')
  _EXTENSION_URL=$(_EXTENSION '.url')
  _EXTENSION_VERSION=$(_EXTENSION '.version')
  _EXTENSION_GNOME_VERSION=$(_EXTENSION '.gnome_version')

  _EXTENSION_FULLNAME="${_EXTENSION_NAME}_gnome${_EXTENSION_GNOME_VERSION}_v${_EXTENSION_VERSION}"

  install_extension "$_EXTENSION_FULLNAME" "$_EXTENSION_URL"
done

# THEME CONFIGURATIONS
echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
read -t 10 -r SELECTED_GNOME_THEME
# default theme is `fluent`
SELECTED_GNOME_THEME="${SELECTED_GNOME_THEME:-fluent}"

sudo mkdir -p $TEMP_WORK_DIR/themes
# if user press 'enter' proceed to default theme installation
if [[ $SELECTED_GNOME_THEME != "" ]]; then
  while [[ ! $SELECTED_GNOME_THEME =~ ^([fluent orchis]) ]]; do
    print_alert "Não foi possível encontrar o tema informado."
    echo -en "Escolha entre: fluent | orchis: "
    read -r SELECTED_GNOME_THEME
  done
fi

download_theme() {
  local THEME=$1
  echo -e "Fazendo o download do tema..."
  git clone $THEME
}

# TODO: install background of themes
# install fluent GTK theme
install_fluent_theme() {
  cd $TEMP_WORK_DIR/themes/Fluent-gtk-theme
  bash install.sh -t purple -s standard -i debian --tweaks round
}

# install orchis GTK theme
install_orchis_theme() {
  cd $TEMP_WORK_DIR/themes/Orchis-theme
  bash install.sh -t purple -s standard --tweaks compact
}

cd $TEMP_WORK_DIR/themes
case $SELECTED_GNOME_THEME in
fluent)
  download_theme https://github.com/vinceliuice/Fluent-gtk-theme.git
  install_fluent_theme
  ;;
orchis)
  download_theme https://github.com/vinceliuice/Orchis-theme.git
  install_orchis_theme
  ;;
esac

# CLEAN VISUAL FILES
cd ~/my-linux
print_success "Configurações visuais aplicadas com sucesso.\nLimpando vestigios de instalação..."
sudo rm -r $TEMP_WORK_DIR

# clean packages and reboot system
REBOOT_TIME=5
sudo apt autoclean && sudo apt autoremove -y
print_header "O sistema será reiniciado em $REBOOT_TIME segundos"
sleep $REBOOT_TIME
sudo reboot
