#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

find_terminal_profile() {
  local target="$1"
  shift
  local ids=("$@")
  local profilesPath="/org/gnome/terminal/legacy/profiles:"

  for id in "${ids[@]}"; do
    local name=$(dconf read $profilesPath/:$id/visible-name)
    if [[ "$name" == "'$target'" ]]; then
      echo "$id"
      return 0
    fi
  done
  return 1
}

create_new_terminal_profile() {
  local profileName="$1"
  local profilesPath="/org/gnome/terminal/legacy/profiles:"
  local profilesIds=($(dconf list $profilesPath/ | grep ^: | sed 's/[\/\:]//g'))
  local profilesIdsOld=$(dconf read "$profilesPath"/list | tr -d "]")
  local newProfileId="$(uuidgen)"

  local targetProfileId=$(find_terminal_profile "$profileName" "${profilesIds[@]}")
  if [[ "$targetProfileId" ]]; then
    echo "$targetProfileId"
    return
  fi

  # check if there is a list and is not empty
  if
    [[ -z "$profilesIdsOld" ]] &&
      [[ "$profilesIdsOld" == "[" ]] &&
      [[ ${#profilesIds[@]} -gt 0 ]]
  then
    local newIds="${profilesIdsOld}, '${newProfileId}']"
    -e dconf write "${profilesPath}/list" "$newIds"
    -e dconf write "${profilesPath}/:${newProfileId}"/visible-name "'${profileName}'"
    echo "$newProfileId"
  fi
}

install_terminal_theme() {
  local dir="${TERMINAL_DIR}"
  local theme="dracula"
  local path="${dir}/${theme}-theme"

  if ! [[ -d "${dir}" ]]; then
    mkdir -p "${dir}"
  fi

  if ! [[ -d "${path}" ]]; then
    print_info "Fazendo o download do tema '${theme}'"
    print_info "Acessando diretório '${dir}'"
    cd "${dir}"
    clone_repo "https://github.com/dracula/gnome-terminal" "${theme}-theme"
  else
    print_info "Arquivos de tema encontrado em ${path}"
    print_info "Pulando etapa de download do tema '${theme}'"
  fi

  print_info "Acessando diretório '${path}'"
  cd "${path}"
  print_info "Executando script de instalação do tema '${theme}'"
  bash install.sh --scheme=Dracula --profile 1 --skip-dircolors
}

print_header "\nConfigurando terminal"
print_info "Instalando dependências"
sudo apt install -y zsh dconf-cli

print_info "Executando script de instalação do 'ohmyzhs'"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_info "Aplicando tema para o terminal"
install_terminal_theme
