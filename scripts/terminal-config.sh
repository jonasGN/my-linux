#!/bin/bash

# config imports
source config/env.conf

# utils imports
source helpers/common
source helpers/prints

_TERMINAL_PROFILE_PATH="/org/gnome/terminal/legacy/profiles:"

# searchs for the given profile name ID. If does not find, returns nothing
find_terminal_profile() {
  local target="$1"
  local ids=($(dconf list $_TERMINAL_PROFILE_PATH/ | grep ^: | sed 's/[\/\:]//g'))

  for id in "${ids[@]}"; do
    local name=$(dconf read $_TERMINAL_PROFILE_PATH/:$id/visible-name)
    if [[ "$name" == "'$target'" ]]; then
      echo "$id"
      return 0
    fi
  done
  return 1
}

create_new_terminal_profile() {
  local profileName="$1"
  local profilesIdsOld=$(dconf read "$_TERMINAL_PROFILE_PATH"/list | tr -d "]")
  local newProfileId="$(uuidgen)"
  local newIds="${profilesIdsOld}, '${newProfileId}']"

  dconf write "${_TERMINAL_PROFILE_PATH}/list" "$newIds"
  dconf write "${_TERMINAL_PROFILE_PATH}/:${newProfileId}"/visible-name "'${profileName}'"
  echo "$newProfileId"
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
    print_info "Arquivos de tema encontrado em '${path}'"
    print_info "Pulando etapa de download do tema '${theme}'"
  fi

  local terminalId=
  local profileName="${theme^}"
  local terminalProfileTargetId=$(find_terminal_profile "$profileName")

  print_info "Procurando pelo perfil '$profileName'"
  if [[ "$terminalProfileTargetId" ]]; then
    print_info "Perfil '$profileName' encontrado"
    terminalId="$terminalProfileTargetId"
  else
    print_info "Perfil '$profileName' não encontrado"
    print_info "Criando perfil para o terminal '$profileName'"
    local newProfileId=$(create_new_terminal_profile "$profileName")
    print_info "ID do perfil '$profileName' ('$newProfileId')"
    terminalId="$newProfileId"
  fi

  print_info "Acessando diretório '${path}'"
  cd "${path}"
  print_info "Executando script de instalação do tema '${theme}'"
  bash install.sh --scheme="Dracula" --profile "$profileName" --skip-dircolors

  print_info "Alterando perfil padrão para '$profileName'"
  dconf write "$_TERMINAL_PROFILE_PATH/default" "'$terminalId'"
}

print_header "\nConfigurando terminal"
print_info "Instalando dependências"
sudo apt install -y zsh dconf-cli

print_info "Executando script de instalação do 'ohmyzhs'"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_info "Aplicando tema para o terminal"
install_terminal_theme

print_observation "Talvez seja necessário reiniciar o terminal para aplicar as novas configurações"
