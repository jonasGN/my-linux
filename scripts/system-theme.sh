#!/bin/bash

# config imports
source config/env.conf
source config/repos.conf
source config/themes.conf

# utils imports
source helpers/common
source helpers/prints

_SYSTEM_THEME="$1"

# enable given theme from legacy apps theme and user themes
set_theme() {
  local theme="$1"
  gsettings set org.gnome.desktop.interface gtk-theme "$theme"
  gsettings set org.gnome.shell.extensions.user-theme name "$theme"
}

install_theme() {
  local theme="$1"
  local name="$2"
  shift 2
  local args=("$@")

  local themeDir="${THEME_DIR}/${theme}"
  print_info "Acessando diretório ${themeDir}"
  cd "${themeDir}"

  print_info "Instalando tema GTK '$theme' do estilo '$name'"
  if ! [[ -d ~/.themes ]]; then
    print_info "Criando diretório de instalação para temas do sistema"
    mkdir -p ~/.themes
  fi
  bash install.sh "${args[@]}"
  print_info "Aplicando tema do sistema"
  set_theme "$name"
}

if is_theme_valid "$_SYSTEM_THEME" "${AVAILABLE_THEMES[@]}"; then
  print_header "\nAplicando tema do sistema '$_SYSTEM_THEME'"
  print_info "Resolvendo dependências necessárias para a instalação do tema"
  sudo apt install -y libsass1 sassc

  print_info "Acessando diretório ${THEME_DIR}"
  cd "$THEME_DIR"

  case "$_SYSTEM_THEME" in
  "fluent")
    clone_repo "${FLUENT_THEME_REPO}" "$_SYSTEM_THEME"
    install_theme "$_SYSTEM_THEME" "Fluent-round-purple-Dark" -t purple -s standard -i debian --tweaks round
    ;;
  "orchis")
    clone_repo "${ORCHIS_THEME_REPO}" "$_SYSTEM_THEME"
    install_theme "$_SYSTEM_THEME" "Orchis-Purple-Dark" -t purple -s standard --tweaks compact
    ;;
  *)
    print_observation "Tema informado não possui suporte ainda :("
    print_info "Instalação do tema so sistema abortada devido a falta de suporte ao tema escolhido"
    exit 0
    ;;
  esac
  print_success "Tema do sistema aplicado com sucesso"
else
  print_alert "\nTema informado não disponível"
fi
