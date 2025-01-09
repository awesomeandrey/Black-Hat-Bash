#!/usr/bin/env bash

# bash playground/exercises/run_os_detection.sh

detect_os() {
  local cmd="$1"
  cmd_error=$(mktemp)
  cmd_result=$(eval "$cmd" 2> "$cmd_error")
  if [[ -s "$cmd_error" ]]; then
    echo "[$cmd] ERROR: $(cat "$cmd_error")"
  else
    echo "[$cmd]: $cmd_result"
  fi
  rm "$cmd_error"
}

detect_os "uname -a"
detect_os "uname -o"
detect_os "hostname"
detect_os "hostnamectl"
detect_os "lsc_release"

os_release_file="/etc/os-release"
if [[ -f "$os_release_file" ]]; then
  echo -e "\n--- OS-RELEASE FILE [$os_release_file] ---\n"
  cat "$os_release_file"
  exit 0
fi
echo "OS Detection Failed!"
exit 1