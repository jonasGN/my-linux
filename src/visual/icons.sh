#!/bin/bash

# SOURCES
source src/setup.sh
source src/beutify.sh
source src/visual/common.sh

_GNOME_ICON_THEME="$1"

set_icon_theme() {
  local ICON_THEME="$1"
  gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
}

install_fluent_icons() {
  print_header "\nInstalando tema de ícones Fluent"
  cd "Fluent-icon-theme"
  bash install.sh -r standard purple
  set_icon_theme "Fluent-purple-dark"
}

install_tela_icons() {
  print_header "\nInstalando tema de ícones Tela"
  cd "Tela-icon-theme"
  bash install.sh standard purple
  set_icon_theme "Tela-purple-dark"
}

cd "$ICONS_WORK_DIR"

case "$_GNOME_ICON_THEME" in
fluent)
  download_repo "https://github.com/vinceliuice/Fluent-icon-theme.git"
  install_fluent_icons
  ;;
orchis)
  download_repo "https://github.com/vinceliuice/Tela-icon-theme.git"
  install_tela_icons
  ;;
esac
