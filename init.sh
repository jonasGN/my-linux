#!/bin/bash

# UTILS
# use `cat /etc/os-release` to see the system version
# use `lsblk` to see the partitions
# use `uname -r` to se the kernel version

# SETUP
ALERT_COLOR="\e[31m"
SUCCESS_COLOR="\e[32m"
RESET_COLOR="\e[0m"

print_alert() {
  echo -e "${ALERT_COLOR}${1}${RESET_COLOR}"
}

print_success() {
  echo -e "${SUCCESS_COLOR}${1}${RESET_COLOR}"
}

# CONFIRMATION
# this script modifies some sensitive configuration, so only executes after user confirmation
print_alert "ATENÇÃO: Esse script modifica arquivos seníveis ao sistema."
echo -n "Tem certeza que deseja continuar? (S/N): "
read -r PROCEED

while [[ ! $PROCEED =~ ^([SN]) ]]; do
  echo -n "Tem certeza que deseja continuar? (S/N): "
  read -r PROCEED
done

if [ $PROCEED == "N" ]; then
  print_success "Script encerrado com sucesso."
  exit 0
fi

# CONSOLE CONFIGURATION
# sudo dpkg-reconfigure console-setup
# set the CHARMAP to UTF-8, CODESET to Lat15, FONTFACE to Terminus and FONTSIZE to 10x18
sudo sed -i 's/CHARMAP=.*/CHARMAP="UTF8"/g' /etc/default/console-setup
sudo sed -i 's/CODESET=.*/CODESET="Lat15"/g' /etc/default/console-setup
sudo sed -i 's/FONTFACE=.*/FONTFACE="Terminus"/g' /etc/default/console-setup
sudo sed -i 's/FONTSIZE=.*/FONTSIZE="10x18"/g' /etc/default/console-setup

# ZRAM CONFIGURATION
sudo apt install -y zram-tools
sudo sed -i 's/#ALGO=.*/ALGO=zstd/g' /etc/default/zramswap
sudo sed -i 's/#PERCENT=.*/PERCENT=25/g' /etc/default/zramswap

# check the settings before apply them
print_alert "ATENÇÃO: Verifique se as configurações estão de acordo com o desejado.
Caso não estejam, você poderá edita-las antes do sistema reiniciar.\n"
cat /etc/default/zramswap

REBOOT_TIME=10
print_alert "\n\nCaso não confirme o sistema será reiniciado automáticamente em: $REBOOT_TIME..."
echo -n "As configurações do Zram estão corretas (s/n) [s]: "
read -t $REBOOT_TIME -rsn1 KEY
# if user do not provide any answer, use default
KEY="${KEY:-s}"

if [ $KEY == "s" ] || [ $KEY == "S" ]; then
  _SLEEP_TIME=5
  print_alert "\nO sistema será reiniciado em $_SLEEP_TIME segundos... (ctrl+c para cancelar)"
  sleep $_SLEEP_TIME
  sudo reboot
else
  sudo nano /etc/default/zramswap
fi
