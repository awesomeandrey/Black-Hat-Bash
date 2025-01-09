#!/usr/bin/env bash

# How to use:
# bash playground/exercises/run_collect_logs.sh
# echo "/" | bash playground/exercises/run_collect_logs.sh

#curr_pwd=$(pwd)
#HOME=$(cd ~; pwd)
#cd "$curr_pwd"

BACKUP_DIR="${HOME}/backup-logs"
BACKUP_DIR_ARCHIVE="${HOME}/backup_logs.tar.gz"

read -rp "Provide Source Directory: " SOURCE_DIR

if [[ -z "$SOURCE_DIR" ]]; then
  SOURCE_DIR="/var/log"
  echo "Defaulted to [$SOURCE_DIR]"
fi

if ! [[ -d "$SOURCE_DIR" ]]; then
  echo "[$SOURCE_DIR] directory does not exist."
  exit 1
fi

if ! [[ -r "$SOURCE_DIR" ]]; then
  echo "[$SOURCE_DIR] directory is not readable."
  exit 1
fi

echo "Searching through [$SOURCE_DIR]..."

temp_output=$(mktemp)

find "$SOURCE_DIR" \
  -readable \
  -type f \
  -name "*.txt" -o -name "*.log" > "$temp_output" 2> /dev/null

files_count=$(wc -l "$temp_output" | awk '{print $1}')

if [[ $files_count -eq 0 ]]; then
  echo "0 files found."
  exit 1
fi

echo "Found $files_count files."

if [[ -d "$BACKUP_DIR" ]]; then
  rm -rf "$BACKUP_DIR"
fi
mkdir -p "$BACKUP_DIR"

echo "Copying files..."
while read -r filepath; do
  cp -f "$filepath" "$BACKUP_DIR" 2> /dev/null
done < "$temp_output"

copied_files_count=$(find "$BACKUP_DIR" -maxdepth 1 -type f | wc -l)
echo "Copied $copied_files_count files."

tar czfP "$BACKUP_DIR_ARCHIVE" "$BACKUP_DIR"
echo "Compressed archive:"
ls -lh "$BACKUP_DIR_ARCHIVE"

# Cleanup
rm -rf "$temp_output"
rm -rf "$BACKUP_DIR"
