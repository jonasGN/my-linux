#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

# export to path to be easy to work with the system files
export MY_LINUX_DIR=$(pwd)

get_app_type() {
  local file="$1"
  local type=$(grep "TYPE" $file | cut -d'"' -f 2)
  echo "$type"
}

install_deb_apps() {
  local file="$1"
  if [[ "$(get_app_type $file)" == "deb" ]]; then
    bash "$file"
  fi
}

install_script_apps() {
  local file="$1"
  if [[ "$(get_app_type $file)" == "script" ]]; then
    bash "$file"
  fi
}

install_apps() {
  for app in $MY_LINUX_DIR/apps/*; do
    print_info "Instalando '$(get_file_name $app)'"
    install_deb_apps "$app"
    install_script_apps "$app"
    echo -en "\n"
  done
}

if ! [[ -d "${MY_LINUX_DIR}/temp/apps" ]]; then
  mkdir -p "${MY_LINUX_DIR}/temp/apps"
fi

print_header "\nInstalando aplicativos de terceiros"
install_apps

# remove variable from path
unset MY_LINUX_DIR
