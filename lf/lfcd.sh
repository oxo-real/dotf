#!/usr/bin/env sh
# https://github.com/gokcehan/lf/blob/b2f8673cb9fbe02cbaac407343e697f2e074f4d4/etc/lfcd.sh

# Change working dir in shell to last dir in lf on exit (adapted from ranger).
#
# You need to either copy the content of this file to your shell rc file
# (e.g. ~/.bashrc) or source this file directly:
#
#     LFCD="/path/to/lfcd.sh"
#     if [ -f "$LFCD" ]; then
#         source "$LFCD"
#     fi
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh
#

lfcd () {

    # creates the lfcd function inside a zsh shell environment
    tmp="$(mktemp)"

    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"

    if [ -f "$tmp" ]; then

	dir="$(\cat "$tmp")"
        rm -f "$tmp"

	if [ -d "$dir" ]; then

	    if [ "$dir" != "$(pwd)" ]; then

		cd "$dir"

	    fi

        fi

    fi
}
