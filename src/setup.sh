#!/bin/bash

# this file includes variables and snipets for setup the enviroment

LOCAL_DIR=$(pwd)
ASSETS_DIR="$LOCAL_DIR/assets"
WORK_DIR=~/my-linux-temp
EXTENSIONS_WORK_DIR="$WORK_DIR/extensions"
THEMES_WORK_DIR="$WORK_DIR/themes"
ICONS_WORK_DIR="$WORK_DIR/icons"
CURSORS_WORK_DIR="$WORK_DIR/cursors"
APPS_WORK_DIR="$WORK_DIR/apps"

mkdir -p "$WORK_DIR" &&
  mkdir -p "$EXTENSIONS_WORK_DIR" &&
  mkdir -p "$THEMES_WORK_DIR" &&
  mkdir -p "$ICONS_WORK_DIR" &&
  mkdir -p "$CURSORS_WORK_DIR" &&
  mkdir -p "$APPS_WORK_DIR"
