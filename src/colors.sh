ALERT_COLOR="\e[31m"
SUCCESS_COLOR="\e[32m"
END_COLOR="\e[0m"

# used when some script needs attention
print_alert() {
  echo -e "$ALERT_COLOR$1$END_COLOR"
}

print_success() {
  echo -e "$SUCCESS_COLOR$1$END_COLOR"
}
