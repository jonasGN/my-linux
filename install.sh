#!/bin/bash

# SETUP
ALERT_COLOR="\e[31m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

TEMP_WORK_DIR=~/my_linux_temp

# update the apt list
sudo apt update

# BASIC TOOLS
BASIC_TOOLS=(
  "git"
  "curl"
)
echo -e $HEADER_COLOR"Instalando pacotes básicos:"$RESET_COLOR
for TOOL in ${BASIC_TOOLS[@]}; do
  sudo apt install -y $TOOL
done

# GNOME INSTALLATION CONFIG
GNOME_PACKAGES=(
  "gnome-session"        #
  "gnome-shell"          # instalado junto com session
  "gnome-backgrounds"    # instalado junto com session
  "gnome-applets"        #
  "gnome-control-center" # instalado junto com session
  "gnome-tweaks"         #
  "mutter"               #
  "gjs"                  # instalado junto com session
)
echo -e $HEADER_COLOR"Instalando pacotes gnome:"$RESET_COLOR
for GNOME_PACKAGE in ${GNOME_PACKAGES[@]}; do
  sudo apt install -y $GNOME_PACKAGE
done

# BASIC APPS CONFIGURATIONS
echo -e $HEADER_COLOR"Instalando pacotes e aplicações básicas"$RESET_COLOR
BASIC_APPS=(
  "gnome-terminal" # terminal padrão
  "vlc"            # reprodutor de vídeo
  "firefox-esr"    #  navegador inicial
  "neofetch"       # informações sobre organizadas sobre a distro
)
for BASIC_APP in ${BASIC_APPS[@]}; do
  sudo apt install -y $BASIC_APP
done
