#!/usr/bin/env bash

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh

fruits=(orange banana apple)

show_details(){
  echo "Fruits: ${fruits[*]}"
  echo "2nd fruit: ${fruits[1]}"
}

show_details

unset fruits[1]

show_details

fruits[1]="pineapple"

show_details

