#!/usr/bin/env bash

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh

read -p "Enter your firstname: " FIRST_NAME
read -p "Enter your lastname: " LAST_NAME
echo "You entered $FIRST_NAME and $LAST_NAME"

touch "output.txt"

date +"%d-%m-%Y" > "output.txt"

echo "$FIRST_NAME $LAST_NAME" >> "output.txt"

cp -f "output.txt" "backup.txt"

cat "output.txt"