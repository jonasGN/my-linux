#!/bin/bash

# utils imports
source helpers/prints

print_header "\nInstalando drivers de sistema"

print_info "Instalando o driver para a CPU" "driver"
source drivers/cpu

print_info "Instalando o driver para a GPU" "driver"
source drivers/gpu
