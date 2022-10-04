#!/bin/bash

# SOURCES
source ../setup.sh
source ../beutify.sh
source common.sh

set_icon_theme() {
  local ICON_THEME="$1"
  gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
}

install_fluent_icons() {
  print_header "Instalando tema de ícones Fluent"
  cd "Fluent-icon-theme"
  bash install.sh -r standard purple
  set_icon_theme "Fluent-purple-dark"
}

install_tela_icons() {
  print_header "Instalando tema de ícones Tela"
  cd "Tela-icon-theme"
  bash install.sh standard purple
  set_icon_theme "Tela-purple-dark"
}

cd "$ICONS_WORK_DIR"

case "$SELECTED_GNOME_THEME" in
fluent)
  download_repo "https://github.com/vinceliuice/Fluent-icon-theme.git"
  install_fluent_icons
  ;;
orchis)
  download_repo "https://github.com/vinceliuice/Tela-icon-theme.git"
  install_tela_icons
  ;;
esac
