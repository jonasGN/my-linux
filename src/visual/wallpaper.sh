#!/bin/bash

source src/setup.sh
source src/beutify.sh
source src/visual/common.sh

_WALLPAPER_THEME="$1"

set_wallpaper() {
  local WALLPAPER="$1"
  gsettings set org.gnome.desktop.background picture-uri "file:///~/.local/share/backgrounds/${WALLPAPER}"
}

install_wallpaper() {
  local THEME="$1"

  local BACKGROUNDS_PATH=~/.local/share/backgrounds
  local BACKGROUND="${THEME}-wallpaper.png"

  print_header "\nInstalando background para o tema $THEME"
  cp -r "$LOCAL_DIR/assets/backgrounds/${BACKGROUND}" "$BACKGROUNDS_PATH"
  set_background ${BACKGROUND}
  print_success "Wallpaper instalado com sucesso"
}

if [[ "$_WALLPAPER_THEME" != "fluent" || "$_WALLPAPER_THEME" != "orchis" ]]; then
  print_alert "Wallpaper para o tema selecionado não encontrado. \nDefinindo wallpaper padrão..."
  install_wallpaper "fluent"
  exit 0
fi

install_wallpaper "$_WALLPAPER_THEME"
