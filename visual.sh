#!/bin/bash

# GNOME VERSION TESTED = 42

# SETUP
ALERT_COLOR="\e[31m"
SUCCESS_COLOR="\e[32m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

TEMP_WORK_DIR=~/my_linux_temp

# GNOME EXTENSIONS
install_extension() {
  # sudo mkdir -p $TEMP_WORK_DIR/extensions
  local EXTENSIONS_WORK_DIR=$TEMP_WORK_DIR/extensions
  local EXTENSION_NAME=$1
  local EXTENSION_URL=$2
  local EXTENSION=$EXTENSIONS_WORK_DIR/$EXTENSION_NAME.zip

  echo -e $HEADER_COLOR"Fazendo o download da extensão: $EXTENSION_NAME"$RESET_COLOR
  curl -L# --create-dirs --output $EXTENSION --url $EXTENSION_URL

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

  _NAME="${_EXTENSION_NAME}_gnome${_EXTENSION_GNOME_VERSION}_v${_EXTENSION_VERSION}"

  install_extension "$_NAME" "$_EXTENSION_URL"
done

# THEME CONFIGURATIONS
echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
read -t 10 -r GNOME_THEME
# default theme is `fluent`
GNOME_THEME="${GNOME_THEME:-fluent}"

sudo mkdir -p $TEMP_WORK_DIR/themes
while [[ ! $GNOME_THEME =~ ^([fluent orchis]) ]]; do
  echo -e $ALERT_COLOR"Não foi possível encontrar o tema informado."$RESET_COLOR
  echo -en "Escolha entre: fluent | orchis: "
  read -r GNOME_THEME
done

download_theme() {
  echo -e "Fazendo o download do tema..."
  git clone $1
}

# TODO: install background of themes
# install fluent GTK theme
install_fluent() {
  cd $TEMP_WORK_DIR/themes/Fluent-gtk-theme
  bash install.sh -t purple -s standard -i debian --tweaks round
}

# install orchis GTK theme
install_orchis() {
  cd $TEMP_WORK_DIR/themes/Orchis-theme
  bash install.sh -t purple -s standard --tweaks compact
}

cd $TEMP_WORK_DIR/themes
case $GNOME_THEME in
fluent)
  download_theme https://github.com/vinceliuice/Fluent-gtk-theme.git
  install_fluent
  ;;
orchis)
  download_theme https://github.com/vinceliuice/Orchis-theme.git
  install_orchis
  ;;
esac

# CLEAN VISUAL FILES
cd ~/my-linux
sudo rm -r $TEMP_WORK_DIR

# clean packages and reboot system
sudo apt autoremove -y
sudo reboot
