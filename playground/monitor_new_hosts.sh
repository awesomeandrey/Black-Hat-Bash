#!/usr/bin/env bash

notify(){
  curl -X POST \
    -H 'Content-type: application/json' \
    --data "{\"text\":\"New host discovered $1\"}" \
    "$SLACK_WEBHOOK_URL"
}

NETWORK_CIDR="172.16.10.0/24"
NETWORK_INTERFACE="br_public"

KNOWN_HOSTS_FILE="172-16-10-hosts.txt"

while true; do
  echo "In a loop"
  sudo arp-scan -I "$NETWORK_INTERFACE" "$NETWORK_CIDR" -x | while read -r line; do
    host=$(echo "$line" | awk '{print $1}')
    if ! grep -q "$host" "$KNOWN_HOSTS_FILE" ; then
      echo "Host $host is NEW"
      notify "$host"
    fi
  done

  sleep 30
done
