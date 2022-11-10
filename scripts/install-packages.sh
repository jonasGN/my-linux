#!/bin/bash

# utils imports
source helpers/common
source helpers/prints

# config imports
source config/folders.conf

# packages imports
source packages/tools.conf
source packages/gnome.conf
source packages/apps.conf

# BASIC TOOLS
print_header "Instalando pacotes básicos"
install_packages "${BASIC_TOOLS[@]}"

# GNOME INSTALLATION
print_header "Instalando pacotes do ambiente gnome"
install_packages "${GNOME_PACKAGES[@]}"
# unistall some gnome apps
print_header "Desinstalado pacotes opcionais do ambiente gnome"
uninstall_packages "${UNINSTALL_GNOME_PACKAGES[@]}"

# BASIC APPS CONFIGURATIONS
print_header "Instalando aplicações básicas"
install_packages "${BASIC_APPS[@]}"
