#!/bin/bash

# utils imports
source helpers/common
source helpers/prints

# config imports
source config/env.conf
source custom.conf

# packages imports
source packages/tools.conf
source packages/gnome.conf
source packages/apps.conf

# BASIC TOOLS
print_header "\nInstalando pacotes básicos"
install_packages "${BASIC_TOOLS[@]}"

# GNOME INSTALLATION
print_header "\nInstalando pacotes do ambiente gnome"
install_packages "${GNOME_PACKAGES[@]}"

# unistall some gnome apps
print_header "\nDesinstalado pacotes opcionais do ambiente gnome"
uninstall_packages "${UNINSTALL_GNOME_PACKAGES[@]}"

# BASIC APPS CONFIGURATIONS
print_header "\nInstalando aplicações básicas"
install_packages "${BASIC_APPS[@]}"

# install custom packages add by user
if file_exists "$CUSTOM_CONFIG_FILE"; then
  if [[ "${#CUSTOM_PACKAGES[@]}" -gt 0 ]]; then
    print_header "\nInstalando pacotes adicionados pelo usuário"
    install_packages "${CUSTOM_PACKAGES[@]}"
  fi

  if [[ "${#CUSTOM_UNINSTALL_PACKAGES[@]}" -gt 0 ]]; then
    print_header "\nDesinstalando pacotes adicionados pelo usuário"
    uninstall_packages "${CUSTOM_UNINSTALL_PACKAGES[@]}"
  fi
fi
