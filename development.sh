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
