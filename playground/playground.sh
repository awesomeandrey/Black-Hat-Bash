#!/usr/bin/env bash

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh

sleep 100 &

echo "Creating file"
touch "test.txt"

echo "Deleting file"
rm -rf "test.txt"
