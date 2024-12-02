#! /usr/bin/env sh

# --------------------------------------------------------------------
# shell-params.sh


# shell parameters
autoload -U colors; colors
setopt auto_pushd


zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish
