#!/bin/bash

# BASIC TOOLS
BASIC_TOOLS="git curl"
for TOOL in $BASIC_TOOLS; do
  sudo apt install -y $TOOL
done

# GNOME INSTALLATION CONFIG
# GNOME_PACKAGES="gnome-tweaks gnome-session"
# for GNOME_PACKAGE in $GNOME_PACKAGES; do
#   sudo apt install -y $GNOME_PACKAGE
# done

# them configuration
# echo -n "Escolha o tema a ser instalado (fluent | orchis) [fluent]: "
# read -t 10 -rs GNOME_THEME
# # default theme is `fluent`
# GNOME_THEME="${GNOME_THEME:-fluent}"

TEMP_WORK_DIR=~/my_linux_temp

mkdir $TEMP_WORK_DIR/themes &&
  cd $TEMP_WORK_DIR/themes &&
  git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
