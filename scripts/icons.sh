#!/bin/bash

# config imports
source config/env.conf
source config/themes.conf
source config/repos.conf

# utils imports
source helpers/common
source helpers/prints

_ICON_THEME="$1"

set_icon_theme() {
  local theme="$1"
  gsettings set org.gnome.desktop.interface icon-theme "$theme"
}

install_icon_theme() {
  local theme="$1"
  local name="$2"
  shift 2
  local args=("$@")

  local iconDir="${ICON_THEME_DIR}/${theme}-icons"
  print_info "Acessando diretório ${iconDir}"
  cd "${iconDir}"

  print_info "Instalando tema de ícones '$theme' do estilo '$name'"
  if ! [[ -d ~/.local/share/icons ]]; then
    print_info "Criando diretório de instalação para temas de ícones"
    mkdir -p ~/.local/share/icons
  fi
  bash install.sh "${args[@]}"
  print_info "Aplicando tema de ícones"
  set_icon_theme "$name"
}

if is_theme_valid "$_ICON_THEME" "${AVAILABLE_THEMES[@]}"; then
  print_header "\nAplicando tema de ícones '${_ICON_THEME}'"
  print_info "Acessando diretório ${ICON_THEME_DIR}"
  cd "$ICON_THEME_DIR"
  case "$_ICON_THEME" in
  "fluent")
    clone_repo "${FLUENT_ICON_THEME_REPO}" "fluent-icons"
    install_icon_theme "$_ICON_THEME" "Fluent-purple-dark" -r standard purple
    ;;
  "orchis")
    clone_repo "${TELA_ICON_THEME_REPO}" "tela-icons"
    install_icon_theme "$_ICON_THEME" "Tela-purple-dark" standard purple
    ;;
  *)
    print_observation "Tema informado não possui suporte ainda :("
    print_info "Instalação de temas de ícones abortada devido a falta de suporte ao tema escolhido"
    exit 0
    ;;
  esac
  print_success "Tema de ícones aplicado com sucesso\n"
else
  print_alert "\nTema informado não disponível"
fi
