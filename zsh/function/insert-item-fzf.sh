#! /usr/bin/env sh

# --------------------------------------------------------------------
# insert-item-fzf.sh


function insert-item-fzf ()
{
    ## fzf insert file- or directory-paths on command line

    fd_path="$1"
    fd_options="$2"
    fzf_prompt="$3"
    fzf_query="$4"

    # fzf query fd search
    case $cd_function in

	1 )
	    ## cd-*-functions enter here (i.e. cd-child)

	    if [[ $fd_path_no_sub_dirs -eq 1 ]]; then

		## cwd has only one subdir
		fzf_output="$(fd --color never --type directory --follow --max-depth 1 . $fd_path)"

	    else

		## if value is '--'; reset fd_options
		[[ $fd_options == '--' ]] && fd_options=''

		## all directories in fd_path
		fd_list_dirs=$(fd --type directory --follow --hidden $fd_options . $fd_path)

		## in this block fzf has no multi selection
		## :abort for cd-child to enter cd-child-joint (pressing C-j twice)
		dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query" --bind ctrl-j:abort)

		fzf_output=$dir_select

	    fi
	    ;;

	* )
	    ## in this block fzf has multi selection
	    if [[ -n $dir_stack ]]; then

		fd_list_items=$dir_stack

	    elif [[ -n $fd_path ]]; then

		## this can take a while, so we give some user feedback
		printf '%s %s .. retrieving file data' "$fzf_prompt" "$fd_path"

		## all files and directories in fd_path
		fd_list_items=$(fd --hidden . $fd_path)

	    fi

	    ## in this block fzf has multi selection
	    ## tr converts multiple fzf entries to one line
	    ## sed remove trailing space
	    fzf_output=$(printf '%s' "$fd_list_items" | \
			     fzf --multi --ansi --prompt="$fzf_prompt " --query="$fzf_query" | \
			     tr '\n' ' ' | \
			     sed 's/[ \t]$//')
	    ;;

    esac

    ## selection to buffer
    [[ -n "$fzf_output" ]] && \
    	CUTBUFFER="$fzf_output" && zle vi-replace-selection
    [[ -z "$fzf_output" ]] && \
    	CUTBUFFER="$fzf_query" && zle vi-put-before

    ## replace selection
    zle put-replace-selection

    unset CUTBUFFER
}
