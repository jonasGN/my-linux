#!/bin/bash

# TERMINAL
# terminal with zsh
sudo apt install -y zsh
if command -v curl &>/dev/null; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  sudo apt install -y curl
fi

# add custom configs for zsh
echo "
### CUSTOM CONFIGS ###

# aliases
# open zshrc bash
alias zshe="nano ~/.zshrc"

# common path variables
LIB_PATH="/usr/lib"
SDKS_PATH="$HOME/.local/share/sdks"
APPS_PATH="/opt"

" | tee -a ~/.zshrc

# INSTALL DEVELOPMENT BASIC PROGRAMS
source src/setup
source src/beutify

# install_app() {
#   local APP_NAME="$1"

#   print_header "\nInstalando ${APP_NAME}..."
#   curl -L --create-dirs --output $EXTENSION --url $URL
# }

# vscode
VSCODE_FILE="${APPS_WORK_DIR}/vscode.deb"
curl -L --create-dirs --output ${VSCODE_FILE} --url "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-"

if [[ -f "$VSCODE_FILE" ]]; then
  print_header "\nInstalando Visual Studio Code..."
  sudo dpkg -i $VSCODE_FILE
fi
