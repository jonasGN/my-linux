#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

# header
# apps type
# TYPE="deb" | only is need the name and url to download the deb package from
# TYPE="script" | apps that already have installation script available from vendor

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
    local appName="$(get_file_name $file).deb"
    local url=$(grep "URL" $file | cut -d'"' -f 2)
    local appFile="${MY_LINUX_DIR}/temp/apps/${appName}"

    # download the deb file
    if ! [[ -f "$appFile" ]]; then
      print_info "Realizando download do arquivo '$appName'"
      cd "${MY_LINUX_DIR}/temp/apps"
      wget -c "$url" -O "$appName" -q --show-progress --progress=bar:force:noscroll
    else
      print_info "Arquivo encontrado em '$appFile'"
      print_info "Pulando etapa de download"
    fi

    print_info "Executando 'sudo apt install' para '$appName'"
    echo sudo apt install -y "$appFile"
  fi
}

install_script_apps() {
  local file="$1"
  if [[ "$(get_app_type $file)" == "script" ]]; then
    print_info "Encontrado script de instalação para a aplicação"
    print_info "Executando script de instalação para '$(get_file_name $file)'"
    echo bash "$file"
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
