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

get_app_type() {
  local file="$1"
  local type=$(grep "TYPE" $file | cut -d'"' -f 2)
  echo "$type"
}

# download_app() {
#   local file="$1"
#   local appName="$(get_file_name $file)"
#   local appFile="${MY_LINUX_DIR}/temp/apps/${appName}"

#   if ! file_exists "$file"; then
#     print_info "Realizando download do arquivo '$appName'"
#     cd "${MY_LINUX_DIR}/temp/apps"
#     wget -c "$url" -O "$appName" -q --show-progress --progress=bar:force:noscroll
#   else
#     print_info "Arquivo encontrado em '$appFile'"
#     print_info "Pulando etapa de download"
#   fi
# }

install_deb_apps() {
  local file="$1"
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
  sudo apt install -y "$appFile"
}

install_script_apps() {
  local file="$1"
  print_info "Encontrado script de instalação para a aplicação"
  print_info "Executando script de instalação para '$(get_file_name $file)'"
  bash "$file"
}

install_apps() {
  for app in $MY_LINUX_DIR/apps/*; do
    print_info "Instalando '$(get_file_name $app)'"

    case "$(get_app_type $app)" in
    "deb")
      install_deb_apps "$app"
      ;;
    "script")
      install_script_apps "$app"
      ;;
    esac
    echo -en "\n"
  done
}

if ! [[ -d "${MY_LINUX_DIR}/temp/apps" ]]; then
  mkdir -p "${MY_LINUX_DIR}/temp/apps"
fi

print_header "\nInstalando aplicativos de terceiros"
install_apps
