#!/bin/bash

# UTILS
# use `cat /etc/os-release` to see the system version
# use `lsblk` to see the partitions
# use `uname -r` to se the kernel version

# utils imports
source helpers/prints
source helpers/common

_ZRAM_FILE=/etc/default/zramswap
_CONSOLE_SETUP_FILE=/etc/default/console-setup

# CONFIRMATION
# this script modifies some sensitive configuration, so only executes after user confirmation
clear
print_alert "ATENÇÃO: Esse script modifica arquivos sensíveis ao sistema."
danger_confirmation "Tem certeza que deseja continuar? [Yes/No]" "Yes" "No"
sudo -v

# CONSOLE CONFIGURATION
if file_exists "$_CONSOLE_SETUP_FILE"; then
  # sudo dpkg-reconfigure console-setup

  print_info "Alterando as configurações do console"
  # set the CHARMAP to UTF-8,
  # CODESET to Lat15,
  # FONTFACE to Terminus and
  # FONTSIZE to 10x18
  sudo sed -i 's/CHARMAP=.*/CHARMAP="UTF8"/g' $_CONSOLE_SETUP_FILE
  sudo sed -i 's/CODESET=.*/CODESET="Lat15"/g' $_CONSOLE_SETUP_FILE
  sudo sed -i 's/FONTFACE=.*/FONTFACE="Terminus"/g' $_CONSOLE_SETUP_FILE
  sudo sed -i 's/FONTSIZE=.*/FONTSIZE="10x18"/g' $_CONSOLE_SETUP_FILE
fi

# ZRAM CONFIGURATION
print_zram_info() {
  local file="$_ZRAM_FILE"

  local algo=$(cat $file | grep -i "algo=")
  local percent=$(cat $file | grep -i "percent=")
  local size=$(cat $file | grep -i "size=")
  local priority=$(cat $file | grep -i "priority=")

  print_success "${algo}\n${percent}\n${size}\n${priority}"
  print_observation "\nOs campos que contém '#' não estão habilitados"
}

wrong_zram_config() {
  if file_exists "$_ZRAM_FILE"; then
    sudo nano $_ZRAM_FILE
    reboot_system "Configurações correspondem ao esperado"
  else
    print_alert "O arquivo de configuração do Zramswap não existe."
  fi
}

print_info "Instalando zram-tools"
sudo apt install -y zram-tools
if file_exists "$_ZRAM_FILE"; then
  sudo sed -i 's/#ALGO=.*/ALGO=zstd/g' $_ZRAM_FILE
  sudo sed -i 's/#PERCENT=.*/PERCENT=25/g' $_ZRAM_FILE

  # check the settings before apply them
  print_alert "ATENÇÃO: Verifique se as configurações estão de acordo com o desejado. \nCaso não estejam, você poderá edita-las antes do sistema reiniciar.\n"
  print_zram_info
else
  print_alert "Arquivo de configuração do Zramswap não encontrado. Verifique o caminho '${_ZRAM_FILE}'"
fi

# appling changes and rebooting
single_char_confirmation "As configurações do Zramswap estão corretas?" wrong_zram_config
reboot_system "Necessário reiniciar para aplicar as configurações"
