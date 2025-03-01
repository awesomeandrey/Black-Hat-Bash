#!/usr/bin/env bash

# bash LAB-PLAYGROUND/exercises/run_cipher.sh

INPUT="$1"

if [[ -z $INPUT ]]; then
  echo -e "Provide input!\nSample usage [ bash $(basename "$0") 'some_text' ]"
  exit 1
fi

enc_rot13() {
  echo "$1" | tr "A-Za-z" "N-ZA-Mn-za-m"
}

dec_rot13() {
  echo "$1" | tr "N-ZA-Mn-za-m" "A-Za-z"
}

echo "Encoded ROT13: $(enc_rot13 "$INPUT")"
echo "Decoded ROT13: $(dec_rot13 "$(enc_rot13 "$INPUT")")"
