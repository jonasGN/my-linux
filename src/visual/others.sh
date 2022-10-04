#!/bin/bash

# SOURCES
source src/setup.sh
source src/beutify.sh

print_header "Carregando configurações das extensões..."
dconf load /org/gnome/shell/extensions/ <"$ASSETS_DIR/extension-settings.dconf"

# to load all uncomment this line (needs the dconf file)
# dconf load / <./src/all-dconf-settings.dconf

print_header "\nCarregando configurações extras de visuais..."
# show weekday on top bar clock
gsettings set org.gnome.desktop.interface clock-show-weekday true

# add minimize and maximize buttons to window top bar
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close

# center new windows
gsettings set org.gnome.mutter center-new-windows true

print_success "Configurações extras de visuais aplicadas com sucesso"
