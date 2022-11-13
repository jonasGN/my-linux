#!/bin/bash

# config
source config/folders.conf
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

if [[ "${AVAILABLE_THEMES[*]}" == *"$_CURSOR_THEME"* ]] || [[ "$_CURSOR_THEME" == "" ]]; then
  print_header "\nAplicando tema de cursor 'white-sur'"
  cd "$CURSORS_WORK_DIR"

  clone_repo "${WHITE_SUR_CURSOR_THEME_REPO}" "white-sur"
  cd "${CURSORS_WORK_DIR}/white-sur"

  print_info "Executando script de instalação do tema de cursor"
  bash install.sh
  print_info "Aplicando tema de cursor"
  set_cursor_theme "WhiteSur-cursors"

  print_success "Tema de cursor aplicado com sucesso\n"
else
  print_alert "\nTema informado não disponível"
fi
