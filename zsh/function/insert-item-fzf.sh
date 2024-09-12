#! /usr/bin/env sh


function insert-item-fzf ()
{
    ## fzf insert file- or directory-paths on command line

    fd_path="$1"
    fzf_prompt="$2"
    fzf_query="$3"

    # fzf query fd search
    case $cd_function in

	1 )
	    ## cd-*-functions enter here (i.e. cd-child)
	    fd_list_dirs=$(fd --type d --hidden . $fd_path)

	    printf '\r'
	    dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	    fzf_output=$dir_select
	    ;;

	* )
	    if [[ -n $dir_stack ]]; then

		fd_list_items=$dir_stack

	    elif [[ -n $fd_path ]]; then

		## this can take a while, so we give some user feedback
		printf '%s %s .. retrieving file data' "$fzf_prompt" "$fd_path"
		#TODO printf '${fg_blue}%s %s${st_def} .. retrieving file data' "$fzf_prompt" "$fd_path"

		fd_list_items=$(fd --hidden . $fd_path)

	    fi

	    ## add qqq-quit-exit-cancel as option
	    fd_list_items=$(printf '%s\n%s' "$fd_list_items" 'qqq-quit-exit-cancel')

	    ## erase line
	    tput el1
	    #printf '\r'

	    ## tr converts multiple fzf entries to one line
	    ## sed remove trailing space
	    fzf_output=$(printf '%s' "$fd_list_items" | fzf -m --prompt="$fzf_prompt " --query="$fzf_query" | \
			      tr '\n' ' ' | \
			            sed 's/[ \t]$//')

	    if [[ $fzf_output =~ 'qqq*' ]]; then

		return 10

	    fi
	    ;;

    esac

    [[ -n "$fzf_output" ]] && \
    	CUTBUFFER="$fzf_output" && zle vi-replace-selection
    [[ -z "$fzf_output" ]] && \
    	CUTBUFFER="$fzf_query" && zle vi-put-before

    # replace selection
    zle put-replace-selection
    #zle vi-put-before
    #zle put-replace-selection

    unset CUTBUFFER
}


