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
	    if [[ $fd_path_no_sub_dirs -eq 1 ]]; then

		## only one subdir
		fzf_output="$(fd --type directory --follow --max-depth 1 . $fd_path)"

	    else

		## remove fd_options if sent value was '--'
		[[ $fd_options == '--' ]] && fd_options=''

		## cd-*-functions enter here (i.e. cd-child)
		## in this block fzf has no multi selection
		#fd_list_dirs=$(fd --type directory --follow --hidden . $fd_path)
		fd_list_dirs=$(fd --type directory --follow --hidden $fd_options . $fd_path)

		printf '\r'
		dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

		#TODO press C-j again for joint search (from witin fzf)
		#dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query" --bind 'ctrl-j:execute:cd-child-joint <(echo {})')
		#dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query" --bind 'ctrl-j:execute:(zle -F cd-child-joint)')
		#dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query" --bind 'ctrl-j:execute:(zle cd-child-joint)')

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
		#TODO printf '${fg_blue}%s %s${st_def} .. retrieving file data' "$fzf_prompt" "$fd_path"

		fd_list_items=$(fd --hidden . $fd_path)

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
