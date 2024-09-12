#! /usr/bin/env sh


function toggle-sudo ()
{
    [[ -z $BUFFER ]] && zle up-history

    if [[ $BUFFER == sudo\ * ]]; then

	## already sudo; remove sudo
	BUFFER="${BUFFER#sudo }"

    else

	## add sudo
	BUFFER="sudo $BUFFER"

    fi

    ## refresh
    zle -R $BUFFER
}

zle -N toggle-sudo
