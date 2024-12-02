#! /usr/bin/env sh


function insert-date-time ()
{
    # add (+=) current date and time to cursor position (C-2)
    # compact readable form of iso8601
    LBUFFER+="$(date +'%Y%m%dT%H%M%SE%s')"
}

zle -N insert-date-time


function insert-epoch ()
{
    LBUFFER+="$(date +'%s')"
}

zle -N insert-epoch
