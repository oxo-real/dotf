#!/bin/zsh

# goto url in wl-copy in current page
printf "%4\r\n" "w3m-control: GOTO $(wl-paste)";

# delete intermediate buffer
printf "w3m-control: DELETE_PREVBUF\r\n"
