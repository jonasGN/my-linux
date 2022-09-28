#!/bin/bash

# UTILS
# use `cat /etc/os-release` to see the system version
# use `lsblk` to see the partitions
# use `uname -r` to se the kernel version

# CONSOLE CONFIGURATION
# sudo dpkg-reconfigure console-setup
# set the CHARMAP to UTF-8, CODESET to Lat15, FONTFACE to Terminus and FONTSIZE to 10x18
sudo sed -i 's/CHARMAP=.*/CHARMAP="UTF8"/g' /etc/default/console-setup
sudo sed -i 's/CODESET=.*/CODESET="Lat15"/g' /etc/default/console-setup
sudo sed -i 's/FONTFACE=.*/FONTFACE="Terminus"/g' /etc/default/console-setup
sudo sed -i 's/FONTSIZE=.*/FONTSIZE="10x18"/g' /etc/default/console-setup

# ZRAM CONFIGURATION
sudo apt install -y zram-tools
sudo echo "
### MY CONFIG ###
ALGO=zstd
PERCENT=25
" >>/etc/default/zramswap

echo "ATENÇÃO: Verifique se as configurações estão de acordo com o desejado"
sudo nano /etc/default/zramswap
