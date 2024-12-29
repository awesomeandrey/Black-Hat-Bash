#!/usr/bin/env bash

NETWORK_MASK="$1"

filename="./ch04/$NETWORK_MASK-potential-targets.txt"
touch "$filename"
echo "" > "$filename"

for num in $(seq 1 254); do
  echo "$NETWORK_MASK.$num" >> "$filename"
done
