#!/bin/bash

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh
# alias playground="bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh"


TARGET_NAME=$1
TARGET_DOMAIN=$2

if [[ -z "$TARGET_NAME" ]] || [[ -z "$TARGET_DOMAIN" ]]; then
  echo "Mandatory arguments are missing"
  exit 1
fi

echo "$TARGET_NAME ($TARGET_DOMAIN)"

PING_RESULT="success"

if ping -c 2 "$TARGET_DOMAIN" | grep -q "not known"; then
  PING_RESULT="failure"
fi

touch "ping_result.csv"
currDate=$(date +%m-%d-%Y)
csvRow=("$TARGET_NAME" "$TARGET_DOMAIN" "$PING_RESULT" "$currDate")

echo "${csvRow[*]}" > "ping_result.csv"
