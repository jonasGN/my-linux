#!/bin/bash

# config
source config/env.conf
source config/repos.conf
source config/themes.conf

# utils imports
source helpers/common
source helpers/prints

_CURSOR_THEME="$1"

# apply cursor theme
set_cursor_theme() {
  local theme="$1"
  gsettings set org.gnome.desktop.interface cursor-theme "$theme"
}

if is_theme_valid "$_CURSOR_THEME" "${AVAILABLE_THEMES[@]}"; then
  print_header "\nAplicando tema de cursor 'white-sur'"
  print_info "Acessando diretório ${CURSOR_THEME_DIR}"
  cd "$CURSOR_THEME_DIR"

  clone_repo "${WHITE_SUR_CURSOR_THEME_REPO}" "white-sur"
  print_info "Acessando diretório ${CURSOR_THEME_DIR}/white-sur"
  cd "${CURSOR_THEME_DIR}/white-sur"

  if ! [[ -d ~/.local/share/icons ]]; then
    print_info "Criando diretório de instalação para temas de cursor"
    mkdir -p ~/.local/share/icons
  fi

  print_info "Executando script de instalação do tema de cursor"
  bash install.sh
  print_info "Aplicando tema de cursor"
  set_cursor_theme "WhiteSur-cursors"

  print_success "Tema de cursor aplicado com sucesso\n"
else
  print_alert "\nTema informado não disponível"
fi
