#!/bin/bash

# SOURCES
source src/setup.sh
source src/beutify.sh
source src/visual/common.sh

_GNOME_THEME="$1"

# enable given theme from legacy apps theme and user themes
set_theme() {
  local THEME="$1"
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
  gsettings set org.gnome.shell.extensions.user-theme name "$THEME"
}

# install fluent GTK theme
install_fluent_theme() {
  print_header "\nInstalando tema Fluent"
  cd "Fluent-gtk-theme"
  bash install.sh -t purple -s standard -i debian --tweaks round
  set_theme "Fluent-round-purple-Dark"
}

# install orchis GTK theme
install_orchis_theme() {
  print_header "\nInstalando tema Orchis"
  cd "Orchis-theme"
  bash install.sh -t purple -s standard --tweaks compact
  set_theme "Orchis-Purple-Dark"
}

cd "$THEMES_WORK_DIR"

case "$_GNOME_THEME" in
fluent)
  download_repo "https://github.com/vinceliuice/Fluent-gtk-theme.git"
  install_fluent_theme
  ;;
orchis)
  download_repo "https://github.com/vinceliuice/Orchis-theme.git"
  install_orchis_theme
  ;;
esac
