#!/bin/bash

# colors
ALERT_COLOR="\e[31m"
SUCCESS_COLOR="\e[32m"
HEADER_COLOR="\e[96m"
RESET_COLOR="\e[0m"

# used when some script needs attention
print_header() {
  echo -e "${HEADER_COLOR}${1}:${RESET_COLOR}"
}

# used when some script is dangerous
print_alert() {
  echo -e "${ALERT_COLOR}${1}${RESET_COLOR}"
}

# used when some script is succeed
print_success() {
  echo -e "${SUCCESS_COLOR}${1}${RESET_COLOR}"
}
