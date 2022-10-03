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

uninstall_packages() {
  local PACKAGES=("$@")

  for PACKAGE in ${PACKAGES[@]}; do
    sudo apt autoremove -y $PACKAGE
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
  "gnome-session"        # gerenciador de sessão
  "gnome-shell"          # instalado junto com session
  "gnome-backgrounds"    # instalado junto com session
  "gnome-applets"        # não instalado com gnome
  "gnome-control-center" # instalado junto com session
  "gnome-tweaks"         #
  "gnome-core"           # utilitários para configurar a área de trabalho
  "gdm3"                 # gerenciador de tela
  "gjs"                  # instalado junto com session

  "gnome-terminal"       # terminal padrão
  "gnome-calculator"     # calculadora padrão (instalado junto ao 'gnome-core')
  "gnome-calendar"       # calendario padrão
  "gnome-characters"     # aplicação de mapa de caracteres (instalado junto ao 'gnome-core')
  "gnome-clocks"         # cronômetro, contagem regressiva e relógio mundial
  "gnome-color-manager"  # integração de gerenciamento de cores para o ambiente de área de trabalho
  "gnome-system-monitor" # visualizador de processo e monitor de recursos
  "gnome-sound-recorder" # simples gravador de som
  "gnome-weather"        # visualizador de clima
)
print_header "Instalando pacotes do ambiente gnome"
install_packages "${GNOME_PACKAGES[@]}"

# unistall some gnome apps
# these section is optional
UNINSTALL_GNOME_PACKAGES=(
  "gnome-contacts"
)
print_header "Desinstalado pacotes opcionais do ambiente gnome"
uninstall_packages "${UNINSTALL_GNOME_PACKAGES[@]}"

# BASIC APPS CONFIGURATIONS
BASIC_APPS=(
  "vlc"              # reprodutor de vídeo mais completo
  "firefox-esr"      #  navegador web
  "neofetch"         # informações sobre organizadas sobre a distro
  "transmission-gtk" # client bittorrent para interface GTK+
)
print_header "Instalando aplicações básicas"
install_packages "${BASIC_APPS[@]}"
