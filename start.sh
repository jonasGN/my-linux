#!bin/bash

# utils imports
source helpers/prints
source helpers/common

print_header "Ao executar esse script, as seguintes alterações serão aplicadas"
echo -e "1 - Instalação de drivers do sistema (CPU, GPU e outros)."
echo -e "2 - Instalação de ferramentas básicas (git, curl e etc)."
echo -e "3 - Instalação do sistema GNOME e de aplicativos do sistema."
echo -e "4 - Instalação de pacotes básicos (navegador, reprodutor de mídia e etc)."

# create temp work folders
source config/folders.conf
print_info "Criando pastas de instalação"
if ! [[ -d "$WORK_DIR" ]]; then
  mkdir -p "$WORK_DIR" &&
    mkdir -p "$EXTENSIONS_WORK_DIR" &&
    mkdir -p "$THEMES_WORK_DIR" &&
    mkdir -p "$ICONS_WORK_DIR" &&
    mkdir -p "$CURSORS_WORK_DIR" &&
    mkdir -p "$APPS_WORK_DIR"
fi

# update repository before continue
print_header "Atualizando repositórios antes de prosseguir"
sudo apt update

# install drivers
bash scripts/drivers.sh

# packages installation
bash scripts/install-packages.sh
