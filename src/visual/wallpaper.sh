#!/bin/bash

source src/setup.sh
source src/beutify.sh
source src/visual/common.sh

_WALLPAPER_THEME="$1"

set_wallpaper() {
  local WALLPAPER="$1"

  local HOME=$(echo ~/)
  gsettings set org.gnome.desktop.background picture-uri "file:///${HOME}.local/share/backgrounds/${WALLPAPER}"
}

install_wallpaper() {
  local THEME="$1"

  local BACKGROUNDS_PATH=~/.local/share/backgrounds
  local BACKGROUND="${THEME}-wallpaper.png"

  print_header "\nInstalando background"
  mkdir -p "$BACKGROUNDS_PATH"
  cp "$LOCAL_DIR/assets/backgrounds/${BACKGROUND}" "$BACKGROUNDS_PATH/"
  set_wallpaper ${BACKGROUND}
  print_success "Wallpaper instalado com sucesso"
}

install_wallpaper "fluent"
