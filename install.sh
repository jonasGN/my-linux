#!/bin/bash

_REPO_URL="https://raw.githubusercontent.com/jonasGN/my-linux/main/install.sh"
_INSTALLATION_DIR=$(pwd)

echo -e "***** My Linux script de instalação *****"
echo -e "Para prosseguir, é necessário permissão de super usuário"
sudo -v

echo -e "Instalando dependências"
sudo apt install -y git

git clone "https://github.com/jonasGN/my-linux.git"
cd "${_INSTALLATION_DIR}/my-linux"

bash "${_INSTALLATION_DIR}/start.sh"
