#!/bin/bash

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh
# alias playground="bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh"


#TARGET_NAME="$1"
#TARGET_DOMAIN="$2"

fileName=$(basename "$0")

echo "Basename is $fileName"
