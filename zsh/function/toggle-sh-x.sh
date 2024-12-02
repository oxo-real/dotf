#! /usr/bin/env sh

# --------------------------------------------------------------------
# toggle-sh-x.sh


function toggle-sh-x ()
{
    [[ -z $BUFFER ]] && zle up-history

    if [[ $BUFFER == sh\ -x\ * ]]; then

	## replace sh -x with sh
	BUFFER="${BUFFER/sh -x /sh }"
	# remove sh -x
	#BUFFER="${BUFFER#sh -x }"

    elif [[ $BUFFER == sh\ * ]]; then

	## add -x to sh
	BUFFER="${BUFFER/sh /sh -x }"

    else

	## add sh -x
	BUFFER="sh -x $BUFFER"

    fi

    zle -R $BUFFER  ## refresh
}

zle -N toggle-sh-x
