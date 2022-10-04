#!/bin/bash

# this file includes common functionalities for visual scripts

download_repo() {
  local REPO="$1"
  echo "Fazendo o download do repositório"
  git clone "$REPO"
}
