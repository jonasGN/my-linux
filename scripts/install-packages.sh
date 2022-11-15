#!/bin/bash

# utils imports
source helpers/common
source helpers/prints

# config imports
source config/env.conf

# packages imports
source packages/tools.conf
source packages/gnome.conf
source packages/apps.conf

# simple to put a new line between installation sections
break_line() {
  echo -en "\n"
}

print_header "\nInstalando pacotes para o sistema"

# BASIC TOOLS
print_info "Instalando pacotes básicos"
install_packages "${BASIC_TOOLS[@]}"
break_line

# GNOME INSTALLATION
print_info "Instalando pacotes do ambiente gnome"
install_packages "${GNOME_PACKAGES[@]}"
break_line

# unistall some gnome apps
print_info "Desinstalado pacotes opcionais do ambiente gnome"
uninstall_packages "${UNINSTALL_GNOME_PACKAGES[@]}"
break_line

# BASIC APPS CONFIGURATIONS
print_info "Instalando aplicações básicas"
install_packages "${BASIC_APPS[@]}"
break_line

# install custom packages add by user
if file_exists "$CUSTOM_CONFIG_FILE"; then
  source custom.conf

  if [[ "${#CUSTOM_PACKAGES[@]}" -gt 0 ]]; then
    print_info "Instalando pacotes adicionados pelo usuário"
    install_packages "${CUSTOM_PACKAGES[@]}"
    break_line
  fi

  if [[ "${#CUSTOM_UNINSTALL_PACKAGES[@]}" -gt 0 ]]; then
    print_info "Desinstalando pacotes adicionados pelo usuário"
    uninstall_packages "${CUSTOM_UNINSTALL_PACKAGES[@]}"
    break_line
  fi
fi

print_success "Pacotes do sistema instalados com sucesso"
