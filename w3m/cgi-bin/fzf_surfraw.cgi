#!/bin/bash

clear

# select elvi
PREFIX=$(surfraw -elvi | grep -v 'LOCAL\|GLOBAL' | fzf -e | awk '{print $1}')

# exit if $PREFIX is empty
[ -z "$PREFIX" ] && exit
# if [ "$PREFIX" = "" ]; then exit; fi

# get user input
read -r -e -p "  $PREFIX >> search keyword: " INPUT

# print proper url and copy
## no quotation on $INPUT!
surfraw -p "$PREFIX" $INPUT | wl-paste
#surfraw -browser=echo "$PREFIX" $INPUT | wl-paste

# copy to tmux clipboard
tmux set-buffer "$(surfraw -p "$PREFIX" $INPUT)"
