#!/bin/bash

# SETUP
ALERT_COLOR="\e[31m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

TEMP_WORK_DIR=~/my_linux_temp

# BASIC TOOLS
BASIC_TOOLS=(
  "git",
  "curl"
)
echo -e $HEADER_COLOR"Instalando pacotes básicos:"$RESET_COLOR
for TOOL in ${BASIC_TOOLS[@]}; do
  sudo apt install -y $TOOL
done

# GNOME INSTALLATION CONFIG
GNOME_PACKAGES=(
  "gnome-session",
  "gnome-shell",
  "gnome-backgrounds",
  "gnome-applets",
  "gnome-control-center",
  "gnome-tweaks",
  "mutter",
  "gjs"
)
echo -e $HEADER_COLOR"Instalando pacotes gnome:"$RESET_COLOR
for GNOME_PACKAGE in ${GNOME_PACKAGES[@]}; do
  sudo apt install -y $GNOME_PACKAGE
done

# theme configuration
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
  cd $TEMP_WORK_DIR/themes/orchis-gtk-theme
  bash install.sh -t purple -s standard --tweaks compact
}

cd $TEMP_WORK_DIR/themes
case $GNOME_THEME in
fluent)
  download_theme https://github.com/vinceliuice/Fluent-gtk-theme.git
  install_fluent
  ;;
orchis)
  download_theme https://github.com/jakschu/orchis-gtk-theme.git
  install_orchis
  ;;
esac

# clean installation
cd ~/my-linux
sudo rm -r $TEMP_WORK_DIR

sudo apt autoremove -y

sudo reboot
