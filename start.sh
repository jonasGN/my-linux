#!bin/bash

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

# create temp work folders
source config/folders.conf
print_info "Criando diretórios de instalação"
if ! [[ -d "$WORK_DIR" ]]; then
  mkdir -p "$WORK_DIR" &&
    mkdir -p "$EXTENSIONS_WORK_DIR" &&
    mkdir -p "$THEMES_WORK_DIR" &&
    mkdir -p "$ICONS_WORK_DIR" &&
    mkdir -p "$CURSORS_WORK_DIR" &&
    mkdir -p "$APPS_WORK_DIR"
fi

# update repository before continue
print_info "Atualizando repositórios antes de prosseguir"
sudo apt update

# # install drivers
# bash scripts/drivers.sh

# # packages installation and gnome DE
# bash scripts/install-packages.sh

# apply themes and visual configs
bash scripts/themes.sh

# clean installation after all
print_observation "Limpando vestigios de instalação"
sudo rm -r "$WORK_DIR"

print_success "Script finalizado com sucesso"
# TODO: reboot system here
