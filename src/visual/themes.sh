#!/bin/bash

# SOURCES
source ../setup.sh
source ../beutify.sh
source common.sh

# echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
# read -t 10 -r SELECTED_GNOME_THEME

# # default theme is `fluent`
# SELECTED_GNOME_THEME="${SELECTED_GNOME_THEME:-fluent}"

# # if user press 'enter' proceed to default theme installation
# if [[ "$SELECTED_GNOME_THEME" != "" ]]; then
#   while [[ ! "$SELECTED_GNOME_THEME" =~ ^([fluent orchis]) ]]; do
#     print_alert "Não foi possível encontrar o tema informado."
#     echo -en "Escolha entre: fluent | orchis: "
#     read -r SELECTED_GNOME_THEME
#   done
# elif [[ "$SELECTED_GNOME_THEME" == "" ]]; then
#   print_header "\nProsseguindo com tema padrão: ($SELECTED_GNOME_THEME)"
# fi

# enable given theme from legacy apps theme and user themes
set_theme() {
  local THEME="$1"
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
  gsettings set org.gnome.shell.extensions.user-theme name "$THEME"
}

# install fluent GTK theme
install_fluent_theme() {
  print_header "Instalando tema Fluent"
  cd "Fluent-gtk-theme"
  bash install.sh -t purple -s standard -i debian --tweaks round
  set_theme "Fluent-round-purple-Dark"
}

# install orchis GTK theme
install_orchis_theme() {
  print_header "Instalando tema Orchis"
  cd "Orchis-theme"
  bash install.sh -t purple -s standard --tweaks compact
  set_theme "Orchis-Purple-Dark"
}

cd "$THEMES_WORK_DIR"

case "$SELECTED_GNOME_THEME" in
fluent)
  download_repo "https://github.com/vinceliuice/Fluent-gtk-theme.git"
  install_fluent_theme
  ;;
orchis)
  download_repo "https://github.com/vinceliuice/Orchis-theme.git"
  install_orchis_theme
  ;;
esac
