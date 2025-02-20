#!/usr/bin/env bash

# bash LAB-PLAYGROUND/exercises/webwhat_banner_by_ip.sh 172.16.10.10:8081 "LAB-PLAYGROUND/assets/scan_result.txt"

target="$1"
file="$2"

output=$(whatweb "$target" --log-json=/dev/stdout --quiet 2>&1) # Capture both stdout and stderr

if [[ "$output" == *"Invalid IP address"* ]] || [[ "$output" == *"ERROR Opening"*  ]]; then # Check for specific error message
  echo -e "Error: Invalid IP address: $target \n" >> "$file"
  exit 1
fi

echo -e "WhatWeb scan completed successfully for $target" >> "$file"
echo -e "$output" | jq '.[0].plugins.HTTPServer.string[0]' >> "$file"
