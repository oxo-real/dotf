#! /usr/bin/env sh

# --------------------------------------------------------------------
# abs-rel-path-tgl.sh


function abs-rel-path-tgl ()
{
    ## select & kill word on cursor (sets CUTBUFFER)
    zle select-in-blank-word
    zle kill-region

    cursor_path="$CUTBUFFER"

    if [[ -e "$cursor_path" ]]; then
	## existing file, directory or symlink

	if [[ "$cursor_path" =~ ^/ ]]; then
	    ## have absolute path
	    ## set relative path

	    tgl_path=$(realpath --relative-to "$PWD" "$cursor_path")

	else
	    ## have relative path
	    ## set absolute path

	    tgl_path="${cursor_path:A}"
	    #tgl_path=$(realpath "$cursor_path")

	fi

	CUTBUFFER="$tgl_path"

	zle vi-put-before

    else

	## no valid path; do nothing
	CUTBUFFER="$cursor_path"
	zle vi-put-before

    fi
}

zle -N abs-rel-path-tgl
