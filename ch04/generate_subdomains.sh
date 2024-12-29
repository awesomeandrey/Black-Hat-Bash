#!/usr/bin/env bash

DOMAIN="$1"
#FILE="$2"

# Option 1

#while read -r subdomain; do
#  echo "$subdomain.$DOMAIN"
#done < "$FILE"

# Option 2

sed "s/$/$DOMAIN/g" "ch04/subdomains-1000.txt"

# See also prebuilt files in Kali
# tail /usr/share/amass/wordlists/subdomains-top1mil-20000.txt
