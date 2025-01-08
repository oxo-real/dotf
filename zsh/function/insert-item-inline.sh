#! /usr/bin/env sh

# --------------------------------------------------------------------
# insert-item-inline.sh


function insert-item-inline ()
{
    # fzf search and select files and directories

    unset srch_env_prmt_arr
    unset srch_env_dir_arr
    unset srch_env_naa
    unset fzf_output
    unset fd_path
    unset fzf_prompt

    ## dir names and their fzf_prompts
    declare -A srch_env_prmt_arr
    srch_env_prmt_arr[CWD]='C'
    srch_env_prmt_arr[HOME]='H'
    srch_env_prmt_arr[ROOT]='R'

    ## dir names and their actual dirs
    declare -A srch_env_dir_arr
    srch_env_dir_arr[CWD]=$PWD
    srch_env_dir_arr[HOME]=$HOME
    srch_env_dir_arr[ROOT]=$ROOT

    ## search and select item(s) in $PWD
    ## fzf_query
    ## select & kill word on cursor
    zle select-in-blank-word
    zle kill-region
    fzf_query="$CUTBUFFER"

    ## dirstack instead of fd_path (below)
    dirstack

    fd_options='--'
    fzf_prompt='S'

    ## offer directories in reach
    insert-item-fzf $dir_stack $fd_options $fzf_prompt $fzf_query

    unset dir_stack
    unset fzf_prompt

    if [[ -n $fzf_output ]]; then

    	zle reset-prompt
     	return 0

    elif [[ -z $fzf_output ]]; then

	## choose search environment
	fzf_prompt='SRCH_ENV'

	## add quit option
	srch_env_dir_arr[ZQXIT]='ZQXIT'

	## iterate over associated array (zsh) and get all keys
	for srch_env_dir in "${(@k)srch_env_dir_arr}"; do

	    ## make (non-acc) array
	    srch_env_naa+=($srch_env_dir)

	done

	## sort array
	IFS=$'\n' srch_env_dirs=($(sort <<< "${srch_env_naa[*]}"))
	unset IFS

	## one item from srch_env_dirs becomes fd_path_sel
	## PWD, HOME, ROOT, ...
	fd_path_sel=$(printf '%s\n' "${srch_env_dirs[@]}" | fzf --prompt "$fzf_prompt ")

	if [[ -z $fd_path_sel || $fd_path_sel == 'ZQXIT' ]]; then

	    zle reset-prompt

	else

	    fd_path=${srch_env_dir_arr[$fd_path_sel]}
	    fd_options='--'
	    fzf_prompt=${srch_env_prmt_arr[$fd_path_sel]}
	    #fzf_query=$fd_path/

     	    insert-item-fzf $fd_path $fd_options $fzf_prompt $fzf_query

	    zle reset-prompt
	    return 0

	fi

    fi
}

zle -N insert-item-inline
