#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/prints
source helpers/common

install_drivers() {
  for driver in $ROOT_DIR/drivers/*; do
    local name=$(get_file_name $driver)
    print_info "Instalando driver relacionado a '$name'"
    bash "$driver"
    echo -en "\n"
  done
}

print_header "\nInstalando drivers de sistema"
install_drivers
print_success "Drivers instalados e configurados com sucesso"
