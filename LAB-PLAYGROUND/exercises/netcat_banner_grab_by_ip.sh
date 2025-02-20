#!/bin/bash

# bash LAB-PLAYGROUND/exercises/netcat_banner_grab_by_ip.sh 172.16.10.10 8081 LAB-PLAYGROUND/assets/scan_result.txt

IP="${1}"
PORT="${2}"
FILE="${3}"

if [[ "$#" -ne 3 ]]; then
  echo "Usage: ${0} <ip> <port> <target_file>"
  exit 1
fi

if [[ ! -f "${FILE}" ]]; then
  echo "File: ${FILE} was not found."
  exit 1
fi

result=$(echo -e "\n" | nc -v "${IP}" -w 1 "${PORT}" 2> /dev/null)
if [[ -n "${result}" ]]; then
  printf '%s' "$result" | grep "Server\|address" >> "$FILE"
fi
