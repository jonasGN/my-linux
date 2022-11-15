#!/bin/bash

# config imports
source config/env.conf
source config/themes.conf

# utils imports
source helpers/common
source helpers/prints

_WALLPAPER="$1"

find_wallpaper_file() {
  local target="$1"
  local file=$(find $ASSETS/wallpapers/* | grep "$target")
  echo $file
}

set_wallpaper() {
  local wallpaper="$1"
  local fileName=$(basename -- "$wallpaper")
  local home=$(echo ~)
  local file="file:///${home}/.local/share/backgrounds/${fileName}"
  gsettings set org.gnome.desktop.background picture-uri "$file"
}

install_wallpaper() {
  local theme="$1"
  local path=~/.local/share/backgrounds
  local wallpaper=$(find_wallpaper_file "$theme")

  if ! [[ -d ~/.local/share/backgrounds ]]; then
    print_info "Criando diretório de instalação para wallpapers"
    mkdir -p "$path"
  fi
  print_info "Copiando wallpaper para $path"
  cp "${wallpaper}" "$path/"

  print_info "Aplicando wallpaper"
  set_wallpaper "$wallpaper"
  print_success "Wallpaper instalado com sucesso\n"
}

print_header "\nConfigurando wallpaper"
print_info "Tema de wallpaper a ser instalado: '$_WALLPAPER'"
if is_theme_valid "$_WALLPAPER" "${AVAILABLE_THEMES[@]}"; then
  install_wallpaper "$_WALLPAPER"
else
  print_alert "Tema informado não disponível"
  print_info "Aplicando wallpaper padrão"
  install_wallpaper "wolf"
fi
