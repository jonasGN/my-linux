#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

get_extension_name() {
  local file="$1"
  local name=$(cat $file | grep "NAME" | cut -d'"' -f 2)
  echo "$name"
}

get_extension_url() {
  local file="$1"
  local url=$(cat $file | grep "URL" | cut -d'"' -f 2)
  echo "$url"
}

get_extension_dependencies() {
  local file="$1"
  local deps=$(grep "DEPENDENCIES" $file | cut -b 15- | sed 's/)//')

  IFS=" "
  read -ra arr <<<"$deps"
  echo "${arr[@]}"
}

# find the full path and extension name
get_extension_file_name() {
  local file="$1"
  local name=$(get_extension_name "$file")
  local extension="${EXTENSIONS_DIR}/${name}.zip"
  echo "$extension"
}

# solve extension dependencies when available
resolve_extension_dependencies() {
  local file="$1"
  if grep -q "DEPENDENCIES" "$file"; then
    local name=$(get_extension_name "$file")
    local dependencies=$(get_extension_dependencies "$file")

    if [[ "${#dependencies[@]}" -lt 1 ]]; then
      return
    fi

    print_info "Dependências para a extensão '$name' encontradas"
    print_info "Resolvendo dependências"
    print_info "Executando 'sudo apt install' para as dependências"
    sudo apt install -y "${dependencies[@]}"
    print_info "Dependências resolvidas com sucesso"
  fi
}

# simple download the extension zip file from official GNOME extensions repo
download_extension() {
  local file="$1"
  local name=$(get_extension_name "$file")
  local url=$(get_extension_url "$file")
  local extensionFile=$(get_extension_file_name "$file")

  if ! file_exists "$extensionFile"; then
    print_info "Fazendo o download da extensão '$name'"
    curl -L --create-dirs --output "$extensionFile" --url "$url" --silent
  else
    print_info "Arquivo de extensão encontrado para '$name'. Pulando etapa de download"
  fi
}

install_extensions() {
  for file in $ROOT_DIR/extensions/*; do
    local name=$(get_extension_name "$file")
    local extensionFile=$(get_extension_file_name "$file")

    download_extension "$file"
    resolve_extension_dependencies "$file"

    print_info "Buscando UUID da extensão '$name'"
    local uuid=$(unzip -c $extensionFile metadata.json | grep uuid | cut -d \" -f4)
    print_info "UUID encontrada [$uuid]"

    print_info "Habilitando extensão '$name'"
    gnome-extensions install "$extensionFile" && gnome-extensions enable "$uuid"
    print_info "Extensão '$name' instalada e habilitada com sucesso\n"
  done
  print_success "Extensões instaladas e configuradas com sucesso\n"
}

print_header "\nInstalando extensões"
print_info "Acessando diretório ${EXTENSIONS_DIR}"
cd "$EXTENSIONS_DIR"
install_extensions
