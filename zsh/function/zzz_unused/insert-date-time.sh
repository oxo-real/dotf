#! /usr/bin/env sh

# --------------------------------------------------------------------
# insert-date-time.sh


function insert-date-time ()
{
    # add (+=) current date and time to cursor position (C-2)
    LBUFFER+="$(ts=$EPOCHREALTIME; printf '%s.%x\n' ${ts%%.*} ${ts#*.})"
    # compact readable form of iso8601
    #LBUFFER+="$(date +'%Y%m%dT%H%M%SE%s')"
}

zle -N insert-date-time


function insert-epoch ()
{
    LBUFFER+="$(date +'%s')"
}

zle -N insert-epoch
