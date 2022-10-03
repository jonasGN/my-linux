#!/bin/bash

# SETUP
ALERT_COLOR="\e[31m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

TEMP_WORK_DIR=~/my_linux_temp

print_header() {
  echo -e "${HEADER_COLOR}${1}:${RESET_COLOR}"
}

install_packages() {
  local PACKAGES=("$@")

  for PACKAGE in ${PACKAGES[@]}; do
    sudo apt install -y $PACKAGE
  done
}

# update the apt list before running installation script
sudo apt update

SYSTEM_PACKAGES=(
  "amd64-microcode" # patches para correção do comportamento para processadores AMD AMD64 (non-free)
  # "intel-microcode" # patches para correção do comportamento para processadores Intel i686 e X86-64 (non-free)
  ""
)
print_header "Instalando pacotes do sistema"
install_packages "${SYSTEM_PACKAGES[@]}"

# BASIC TOOLS
BASIC_TOOLS=(
  "git"
  "curl"
)
print_header "Instalando pacotes básicos"
install_packages "${BASIC_TOOLS[@]}"

# GNOME INSTALLATION CONFIG
GNOME_PACKAGES=(
  # "mutter"               # necessário? (acho que não)
  "gnome-session"        # gerenciador de Sessão GNOME
  "gnome-shell"          # instalado junto com session
  "gnome-backgrounds"    # instalado junto com session
  "gnome-applets"        # não instalado com gnome
  "gnome-control-center" # instalado junto com session
  "gnome-tweaks"         #
  "gnome-terminal"       # terminal padrão
  "gdm3"                 # gerenciador de tela do GNOME
  "gjs"                  # instalado junto com session
)
print_header "Instalando pacotes do ambiente gnome"
install_packages "${GNOME_PACKAGES[@]}"

# BASIC APPS CONFIGURATIONS
BASIC_APPS=(
  "vlc"         # reprodutor de vídeo
  "firefox-esr" #  navegador inicial
  "neofetch"    # informações sobre organizadas sobre a distro
)
print_header "Instalando aplicações básicas"
install_packages "${BASIC_APPS[@]}"
