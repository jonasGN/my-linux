#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

install_terminal_theme() {
  local dir="${TERMINAL_DIR}"
  local theme="dracula"
  local path="${dir}/${theme}-theme"

  if ! [[ -d "${dir}" ]]; then
    mkdir -p "${dir}"
  fi

  if ! [[ -d "${path}" ]]; then
    print_info "Fazendo o download do tema '${theme}'"
    clone_repo "https://github.com/dracula/gnome-terminal" "${theme}-theme"
  else
    print_info "Arquivos de tema encontrado em ${path}"
    print_info "Pulando etapa de download do tema '${theme}'"
  fi

  print_info "Acessando diretório '${path}'"
  cd "${path}"
  print_info "Executando script de instalação do tema '${theme}'"
  bash install.sh
}

print_header "\nConfigurando terminal"
print_info "Instalando dependências"
sudo apt install -y zsh dconf-cli

print_info "Executando script de instalação do 'ohmyzhs'"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_info "Aplicando tema para o terminal"
install_terminal_theme
