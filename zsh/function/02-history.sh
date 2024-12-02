#! /usr/bin/env sh

# --------------------------------------------------------------------
# 02-history.sh


# history settings

hist_cmd_offset=100000

## history shell options
## see man zshoptions (history)

## save timestamp and duration
setopt EXTENDED_HISTORY

## when trimming history file, first trim from duplicate entries
setopt HIST_EXPIRE_DUPS_FIRST

## prefix a command with a space keeps it out of history
setopt HIST_IGNORE_SPACE

## remove superfluous blanks
setopt HIST_REDUCE_BLANKS

## writing options
## WARNING these three options are mutually exclusive
setopt SHARE_HISTORY
#setopt INC_APPEND_HISTORY
#setopt INC_APPEND_HISTORY_TIME
