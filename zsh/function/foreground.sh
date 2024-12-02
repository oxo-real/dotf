#! /usr/bin/env sh

# --------------------------------------------------------------------
# foreground.sh


function foreground ()
{
    ## bring background jobs to the foreground
    fg
}

zle -N foreground
