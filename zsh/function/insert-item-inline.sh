#! /usr/bin/env sh


function insert-item-inline ()
{
    # fzf search and select files and directories

    ##  order   fd_path (no cycle):
    ### 1 S --0 $dir_stack
    ### 2 C --0 $PWD
    ### 3 H --0 $HOME
    ### 4 R --0 $ROOT

    ## search and select item(s) in $PWD
    ## fzf_query
    ## select & kill word on cursor
    zle select-in-blank-word
    zle kill-region
    fzf_query="$CUTBUFFER"

    ## dirstack instead of fd_path (below)
    get-dirstack
    fzf_prompt='S'

    ## add option qqq-quit-exit-cancel
    dir_stack=$(printf '%s\n%s' "$dir_stack" 'qqq-quit-exit-cancel')

    insert-item-fzf $dir_stack $fzf_prompt $fzf_query

    if [[ -n $fzf_output ]]; then

	zle reset-prompt
	return 0

    elif [[ -z $fzf_output ]]; then

	## search and select item(s) in $PWD
	unset fzf_output
	unset dir_stack
	unset fzf_prompt
	fd_path="$PWD"
	fzf_prompt='C'

	insert-item-fzf $fd_path $fzf_prompt $fzf_query

	if [[ -n $fzf_output ]]; then

	    zle reset-prompt
	    return 0

	elif [[ -z $fzf_output ]]; then

	    ## search and select item(s) in $HOME
	    unset fzf_output
	    unset fd_path
	    unset fzf_prompt
	    fd_path="$HOME"
	    fzf_prompt='H'

	    insert-item-fzf $fd_path $fzf_prompt $fzf_query

	    if [[ -n $fzf_output ]]; then

		zle reset-prompt
		return 0

	    elif [[ -z $fzf_output ]]; then

		## search and select item(s) in $ROOT
		unset fzf_output
		unset fd_path
		unset fzf_prompt
		fd_path="$ROOT"
		fzf_prompt='R'

		insert-item-fzf $fd_path $fzf_prompt $fzf_query

		if [[ -n $fzf_output ]]; then

		    zle reset-prompt
		    return 0

		elif [[ -z $fzf_output ]]; then

		    unset fzf_output
		    unset fd_path
		    unset fzf_prompt

		fi

	    fi

	fi

    fi
}

zle -N insert-item-inline
