#! /usr/bin/env sh
cal -m -w -3 $(date -I)
read -n 1 -r -s # wait for a touch key to exit the terminal
