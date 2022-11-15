#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

# use the command bellow to dump the configs from your system. The extension of the file does not matter
# extensions $ dconf dump /org/gnome/shell/extensions/ > extension-settings.conf
# all $ dconf dump / > all-dconf.conf
# to load the configs to your system use:
# extensions $ dconf load /org/gnome/shell/extensions/ $path_where_config_is.conf
# all $ dconf load / < $path_where_config_is.conf

print_header "\nAplicando configurações visuais do sistema"
print_info "Carregando configurações das extensões"
dconf load /org/gnome/shell/extensions/ <"$ROOT_DIR/config/extension-settings.conf"
print_info "Configurações das extensões carregadas"

# show weekday on top bar clock
print_info "Configurando relógio da barra superior"
gsettings set org.gnome.desktop.interface clock-show-weekday true

# add minimize and maximize buttons to window top bar
print_info "Adicionando botões 'minimizar', 'maximizar' e 'fechar' à barra superior das janelas"
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close

# center new windows
print_info "Centralizando novas janelas"
gsettings set org.gnome.mutter center-new-windows true

print_success "Configurações visuais aplicadas com sucesso"
