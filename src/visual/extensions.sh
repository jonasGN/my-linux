#!/bin/bash

# SOURCES
source ../setup.sh
source ../beutify.sh

# VARIABLES
LOCAL_PATH=$(pwd)

install_extension_dependencies() {
  local DEPENDENCIES=("$@")

  if [[ $(echo "${#DEPENDENCIES[@]}") -gt 0 ]]; then
    print_header "Instalando dependências da extensão"
    sudo apt install -y ${DEPENDENCIES[*]}
  fi
}

install_extension() {
  local NAME="$1"
  local URL="$2"

  local EXTENSION="$EXTENSIONS_WORK_DIR/$NAME.zip"

  print_header "Fazendo o download da extensão $NAME"
  curl -L --create-dirs --output $EXTENSION --url $URL

  print_header "Instalando extensão"
  local UUID=$(unzip -c $EXTENSION metadata.json | grep uuid | cut -d \" -f4)
  gnome-extensions install "$EXTENSION" && gnome-extensions enable "$UUID"
  print_success "Extensão instalada com sucesso.\n"
}

for ROW in $(cat "../extensions.json" | jq -r '.[] | @base64'); do
  _EXTENSION() {
    echo ${ROW} | base64 --decode | jq -r ${1}
  }

  _EXTENSION_NAME=$(_EXTENSION '.name')
  _EXTENSION_URL=$(_EXTENSION '.url')
  _EXTENSION_VERSION=$(_EXTENSION '.version')
  _EXTENSION_GNOME_VERSION=$(_EXTENSION '.gnome_version')
  _EXTENSION_DEPENDENCIES+=($(_EXTENSION '.dependencies[]'))

  _EXTENSION_FULLNAME="${_EXTENSION_NAME}_gnome${_EXTENSION_GNOME_VERSION}_v${_EXTENSION_VERSION}"

  echo -e "name: $_EXTENSION_NAME\nversion: $_EXTENSION_VERSION"

  install_extension_dependencies "${_EXTENSION_DEPENDENCIES[@]}"
  install_extension "$_EXTENSION_FULLNAME" "$_EXTENSION_URL"
done
