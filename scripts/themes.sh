#!/bin/bash

# config
source config/themes.conf

# utils imports
source helpers/prints
source helpers/common

# check if has gnome running and its current version
_MIN_GNOME_VERSION=42
_CURRENT_GNOME_VERSION=$(gnome-shell --version | tr -cd '[[:digit:]].')
_CURRENT_DESKTOP_XDG=$(env | grep -E '^XDG_CURRENT_DESKTOP=')
_SELECTED_THEME=

# only runs if it is a GNOME enviroment
print_info "Verificando ambiente de desktop"
if ! grep -qi "gnome" <<<"$_CURRENT_DESKTOP_XDG"; then
  print_alert "Você está executando este script fora do ambiente GNOME sem suporte."
  print_success "Operação abortada devido à incompatibilidade."
  exit 0
fi

# check GNOME version compatibility
if awk 'BEGIN{exit ARGV[1]>=ARGV[2]}' "$_CURRENT_GNOME_VERSION" "$_MIN_GNOME_VERSION"; then
  print_alert "Sua versão do GNOME (v${_CURRENT_GNOME_VERSION}) é incompatível com a versão mínima suportada (v${_MIN_GNOME_VERSION})."
  single_char_confirmation "Deseja continuar mesmo assim?"
else
  print_info "Versão do GNOME instalada compatível (v${_CURRENT_GNOME_VERSION})"
fi

# choose theme
print_theme_info() {
  local theme="$1"
  local icons="$2"
  local cursor="${3:-"white sur"}"
  print_observation "O Tema ${theme^}, conta com as seguintes configurações:"
  echo -e "* Tema do sistema: (${theme})"
  echo -e "* Tema de ícones: (${icons})"
  echo -e "* Tema de cursor: (${cursor})"
}

get_theme() {
  local themes=("${AVAILABLE_THEMES[@]}")
  print_header "\nEscolha um dos temas disponíveis a seguir para prosseguir"
  print_list "${themes[@]}"

  local theme=$(wait_valid_input "Tema" "${themes[@]}")
  print_success "Tema selecionado [$theme]"
  case "$theme" in
  "fluent")
    print_theme_info "fluent" "fluent"
    ;;
  "orchis")
    print_theme_info "orchis" "tela"
    ;;
  esac
  _SELECTED_THEME="$theme"
}

# runs once before looping into "[Nn]" answer
get_theme
while true; do
  read -rp "Deseja manter sua escolha ou escolher novamente? [y/n]: " _answer
  if [[ "$_answer" =~ [Nn] ]]; then
    clear
    get_theme
  else
    break
  fi
done

case "$_SELECTED_THEME" in
"fluent")
  # cursor installation script
  bash "scripts/cursors.sh" "$_SELECTED_THEME"

  # # icon theme installation script
  # bash "$LOCAL_DIR/src/visual/icons.sh" "$SELECTED_GNOME_THEME"

  # # cursors theme installation script
  # bash "$LOCAL_DIR/src/visual/cursors.sh"
  ;;

"orchis") ;;
esac

# # extension installation script
# bash "$LOCAL_DIR/src/visual/extensions.sh"

# echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
# read -t 10 -r SELECTED_GNOME_THEME

# # default theme is `fluent`
# SELECTED_GNOME_THEME="${SELECTED_GNOME_THEME:-fluent}"

# # if user press 'enter' proceed to default theme installation
# if [[ "$SELECTED_GNOME_THEME" != "" ]]; then
#   while [[ ! "$SELECTED_GNOME_THEME" =~ ^([fluent orchis]) ]]; do
#     print_alert "Não foi possível encontrar o tema informado."
#     echo -en "Escolha entre: fluent | orchis: "
#     read -r SELECTED_GNOME_THEME
#   done
# elif [[ "$SELECTED_GNOME_THEME" == "" ]]; then
#   print_header "\nProsseguindo com tema padrão: ($SELECTED_GNOME_THEME)"
# fi

# print_header "\nTema selecionado = $SELECTED_GNOME_THEME"

# # theme installation script
# bash "$LOCAL_DIR/src/visual/themes.sh" "$SELECTED_GNOME_THEME"

# # icon theme installation script
# bash "$LOCAL_DIR/src/visual/icons.sh" "$SELECTED_GNOME_THEME"

# # cursors theme installation script
# bash "$LOCAL_DIR/src/visual/cursors.sh"

# # wallpaper config script
# bash "$LOCAL_DIR/src/visual/wallpaper.sh" "$SELECTED_GNOME_THEME"

# # other visual configs stuff
# bash "$LOCAL_DIR/src/visual/others.sh"

# # CLEAN VISUAL CACHE FILES
# print_success "Configurações visuais aplicadas com sucesso.\nLimpando cache de instalação..."
# sudo rm -r "$WORK_DIR"

# # clean packages and reboot system
# REBOOT_TIME=5
# sudo apt autoclean && sudo apt autoremove -y
# print_success "Tudo certo"
# print_header "O sistema será reiniciado em $REBOOT_TIME segundos"
# sleep $REBOOT_TIME
# sudo reboot
