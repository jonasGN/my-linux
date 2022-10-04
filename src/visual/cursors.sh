#!/bin/bash

# SOURCES
source src/setup.sh
source src/beutify.sh
source src/visual/common.sh

set_cursor_theme() {
  local CURSOR_THEME="$1"
  gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
}

print_header "\nInstalando tema de cursor WhiteSur"
cd "$CURSORS_WORK_DIR"

download_repo "https://github.com/vinceliuice/WhiteSur-cursors.git"
cd "$CURSORS_WORK_DIR/WhiteSur-cursors"

bash install.sh
set_cursor_theme "WhiteSur-cursors"

print_success "Tema de cursor aplicado com sucesso\n"
