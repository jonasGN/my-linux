#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/prints
source helpers/common

_CHANGES_TO_APPLY=(
  "Instalação de drivers do sistema (CPU, GPU e outros)."
  "Instalação de ferramentas básicas (git, curl e etc)."
  "Instalação do sistema GNOME e de aplicativos do sistema."
  "Instalação de pacotes básicos (navegador, reprodutor de mídia e etc)."
  "Instalação de pacotes básicos (navegador, reprodutor de mídia e etc)."
  "Aplicação de temas do sistema, ícones e cursores."
  "Alteração de configurações visuais do sistema."
)

# header
print_header "Ao executar esse script, as seguintes alterações serão aplicadas"
print_list "${_CHANGES_TO_APPLY[@]}"

single_char_confirmation "Deseja continuar?"
print_observation "Para continuar é preciso dar permissão de super usuário"
sudo -v
clear
print_header "***** SCRIPT DE AUTOMATIZAÇÃO CUSTOMIZADA PARA DEBIAN *****"
print_info "Iniciando processo de instalação customizada"

# export temp work dir variable
print_info "Exportando variável temporária"
export MY_LINUX_DIR=$(pwd)

# create temp work folders
print_info "Criando diretórios de instalação"
if ! [[ -d "$TEMP_DIR" ]]; then
  mkdir -p "$APPS_DIR" &&
    mkdir -p "$THEME_DIR" &&
    mkdir -p "$ICON_THEME_DIR" &&
    mkdir -p "$CURSOR_THEME_DIR" &&
    mkdir -p "$EXTENSIONS_DIR"

fi

# update repository before continue
print_info "Atualizando repositórios antes de prosseguir"
sudo apt update

# install drivers
bash scripts/drivers.sh

# packages installation, tools, basico apps and gnome DE
bash scripts/install-packages.sh

# install GNOME extensions
bash scripts/extensions.sh

# apply themes and visual configs
bash scripts/themes.sh

# apply system visual configs, like window position and window buttons
bash scripts/visual-config.sh

# install third party apps
bash scripts/install-apps.sh

# config terminal
bash scripts/terminal-config.sh

# clean installation after all
print_observation "\nLimpando vestigios de instalação"
sudo rm -r "$TEMP_DIR"
unset MY_LINUX_DIR

print_success "Script finalizado com sucesso"
reboot_system "As alterações só terão efeito após reiniciar o sistema"
