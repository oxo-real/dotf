#! /usr/bin/env sh

# --------------------------------------------------------------------
# cd-funcs.sh


function cd-nav-dirs ()
{
    # cd navigate directories with fzf

    ## dir names and their fzf_prompts
    declare -A srch_env_prmt_arr
    srch_env_prmt_arr[PWD]='C'
    srch_env_prmt_arr[HOME]='H'
    srch_env_prmt_arr[ROOT]='R'

    ## dir names and their actual dirs
    declare -A srch_env_dir_arr
    srch_env_dir_arr[PWD]=$PWD
    srch_env_dir_arr[HOME]=$HOME
    srch_env_dir_arr[ROOT]=$ROOT

    ## generate dir_stack
    dir-stack
    fzf_prompt='S'

    #TODO case select is '~', starts with ~ or contains ~
    dir_stack_select_fzf=$(printf '%s' "$dir_stack" | fzf --prompt "$fzf_prompt ")

    if [[ -d "$dir_stack_select_fzf" ]]; then

	## dir_select_fzf is a valid:
	### absolute directory, or
	### child in cwd

	## insert at cursor position
	### insert and keep cursor in place
	#RBUFFER="cd ${dir_select_fzf}${RBUFFER}"
	### insert and move cursor eol
	#LBUFFER+="cd $dir_select_fzf"
	### overwrite entire buffer and keep cursor in place
	#BUFFER="cd $dir_select_fzf"
	### overwrite entire buffer and move cursor eol
	BUFFER="cd $dir_stack_select_fzf"
	zle vi-add-eol

    elif [[ -n $dir_stack_select_fzf ]]; then

	## dir_select_fzf is no valid absolute directory
	## nor from cwd accessible relative directory
	## test if (relative) dir exist somewhere in the filesystem
	fd_path=$ROOT
	fzf_prompt='R'
	fd_pattern="$dir_stack_select_fzf"
	fzf_query="$fd_pattern"

	fd_list_dirs=$(fd --type d --hidden --full-path "$fd_pattern" $fd_path)

	dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	if [[ -d $dir_select ]]; then

	    ## dir_pwd_select is a directory
	    BUFFER="cd ${dir_select}"
	    zle vi-add-eol

	# elif [[ ! -d $dir_select || -z $dir_select ]]; then

	    # printf '%s directory not found\n' "$fzf_query"
	    # TODO printf '${fg_amber}%s${st_def} directory not found\n' "$fzf_query"
	    # return 100

	fi

    elif [[ -z $dir_stack_select_fzf ]]; then

	## choose search environment
	fzf_prompt='SRCH_ENV'

	## iterate over arr and get all keys
	for srch_env_dir in "${(@k)srch_env_dir_arr}"; do

	    srch_env_dirs+=($srch_env_dir)
	    ## DEV TODO clear array

	done

	## one item from srch_env_dirs becomes fd_path_sel
	## PWD, HOME, ROOT, ...
	fd_path_sel=$(printf '%s\n' "${srch_env_dirs[@]}" | fzf --prompt "$fzf_prompt ")

	#[[ -z $fd_path_sel ]] && exit 0

	fd_path=${srch_env_dir_arr[$fd_path_sel]}
	fzf_prompt=${srch_env_prmt_arr[$fd_path_sel]}
	fzf_query=$fd_path/

	## select a directory under $fd_path
	fd_list_dirs=$(fd --type d --hidden . $fd_path)

	dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	# if [[ -z "$dir_select" ]]; then

	    # exit 0

	if [[ -d $dir_select ]]; then

	    ## dir_pwd_select is a directory
	    BUFFER="cd ${dir_select}"
	    zle vi-add-eol

	fi

    fi

    unset srch_env_dirs

    zle -K viins
}

zle -N cd-nav-dirs


function cd-child ()
{
    ## search and select directories from cwd and deeper
    zle kill-line

    ## set variables
    cd_function=1
    fzf_prompt='C'
    fd_path=$PWD

    insert-item-fzf $fd_path $fzf_prompt

    ## reset cd_function
    cd_function=''

    ## place and execute 'cd'
    [[ -n $fzf_output ]] && BUFFER="cd $BUFFER" && zle accept-line
}

zle -N cd-child


function cd-up ()
{
    ## go to parent directory
    BUFFER="cd .."
    zle accept-line
}

zle -N cd-up


function cd-lf ()
{
    ## go to active directory when lf exits

    ## for precmd:
    ## get t0 for $time_exec (ns)
    t0_exec_ns=$(date +'%s%N')

    printf 'cd-lf\n'
    lf_output=$(command lf -print-last-dir "$@")
    #cd $(command lf -print-last-dir "$@")

    ## place and execute 'cd'
    [[ -n $lf_output ]] && BUFFER="cd $lf_output"

    precmd
}

zle -N cd-lf
