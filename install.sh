#!/bin/bash

# basic tools
BASIC_TOOLS="git curl"

for TOOL in $BASIC_TOOLS; do
  sudo apt install -y $TOOL
done
