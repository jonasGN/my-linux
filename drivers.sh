#!/bin/bash
source src/beutify.sh

print_header "Instalando drivers de sistema"
sudo apt update

source drivers/gpu
source drivers/cpu
