#!/bin/bash

# SOURCES
source ../beutify.sh

print_header "Carregando configurações das extensões..."
dconf load /org/gnome/shell/extensions/ <"../extension-settings.dconf"

# to load all uncomment this line (needs the dconf file)
# dconf load / <./src/all-dconf-settings.dconf

# show weekday on top bar clock
gsettings set org.gnome.desktop.interface clock-show-weekday true

# add minimize and maximize buttons to window top bar
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close

# center new windows
gsettings set org.gnome.mutter center-new-windows true
