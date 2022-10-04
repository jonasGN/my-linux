#!/bin/bash

# GNOME VERSION TESTED = 42

# SOURCES
source src/setup.sh
source src/beutify.sh

# extension installation script
bash "$LOCAL_DIR/src/visual/extensions.sh"

echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
read -t 10 -r SELECTED_GNOME_THEME

# default theme is `fluent`
SELECTED_GNOME_THEME="${SELECTED_GNOME_THEME:-fluent}"

# if user press 'enter' proceed to default theme installation
if [[ "$SELECTED_GNOME_THEME" != "" ]]; then
  while [[ ! "$SELECTED_GNOME_THEME" =~ ^([fluent orchis]) ]]; do
    print_alert "Não foi possível encontrar o tema informado."
    echo -en "Escolha entre: fluent | orchis: "
    read -r SELECTED_GNOME_THEME
  done
elif [[ "$SELECTED_GNOME_THEME" == "" ]]; then
  print_header "\nProsseguindo com tema padrão: ($SELECTED_GNOME_THEME)"
fi

print_header "\nTema selecionado = $SELECTED_GNOME_THEME"

# theme installation script
bash "$LOCAL_DIR/src/visual/themes.sh" "$SELECTED_GNOME_THEME"

# icon theme installation script
bash "$LOCAL_DIR/src/visual/icons.sh" "$SELECTED_GNOME_THEME"

# cursors theme installation script
bash "$LOCAL_DIR/src/visual/cursors.sh"

# wallpaper config script
bash "$LOCAL_DIR/src/visual/wallpaper.sh" "$SELECTED_GNOME_THEME"

# other visual configs stuff
bash "$LOCAL_DIR/src/visual/others.sh"

# CLEAN VISUAL CACHE FILES
print_success "Configurações visuais aplicadas com sucesso.\nLimpando cache de instalação..."
sudo rm -r "$WORK_DIR"

# clean packages and reboot system
REBOOT_TIME=5
sudo apt autoclean && sudo apt autoremove -y
print_success "Tudo certo"
print_header "O sistema será reiniciado em $REBOOT_TIME segundos"
sleep $REBOOT_TIME
sudo reboot
