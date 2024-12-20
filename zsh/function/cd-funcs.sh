#! /usr/bin/env sh

# --------------------------------------------------------------------
# cd-funcs.sh


function cd-nav-dirs ()
{
    # cd navigate directories with fzf

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

    ## generate dir_stack
    dir-stack
    fzf_prompt='S'

    dir_stack_select_fzf=$(printf '%s' "$dir_stack" | fzf --prompt "$fzf_prompt ")

    if [[ -d $dir_stack_select_fzf ]]; then

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

	printf "  acquiring ${(k)srch_env_dir_arr[(r)$fd_path]} data  [ C-c > abort ]\r"

	fd_list_dirs=$(fd --type d --hidden --full-path "$fd_pattern" $fd_path)

	dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	if [[ -d $dir_select ]]; then

	    ## dir_pwd_select is a directory
	    BUFFER="cd ${dir_select}"
	    zle vi-add-eol

	fi

    elif [[ -z $dir_stack_select_fzf ]]; then

	## choose search environment
	fzf_prompt='SRCH_ENV'

	## add cancel option
	srch_env_dir_arr[ZQXIT]='ZQXIT'

	## iterate over associated arr and get all keys
	for srch_env_dir in "${(@k)srch_env_dir_arr}"; do

	    ## make (non-acc) array
	    srch_env_naa+=($srch_env_dir)

	    ## sort array
	    IFS=$'\n' srch_env_dirs=($(sort <<< "${srch_env_naa[*]}"))
	    unset IFS

	done

	## one item from srch_env_dirs becomes fd_path_sel
	## PWD, HOME, ROOT, ...
	fd_path_sel=$(printf '%s\n' "${srch_env_dirs[@]}" | fzf --no-sort --prompt "$fzf_prompt ")

	if [[ -z $fd_path_sel || $fd_path_sel == 'ZQXIT' ]]; then

	    zle reset-prompt

	elif [[ $fd_path_sel == 'PWD' ]]; then

	    cd-child-joint

	else

	    ## HOME or ROOT
	    fd_path=${srch_env_dir_arr[$fd_path_sel]}
	    fzf_prompt=${srch_env_prmt_arr[$fd_path_sel]}
	    fzf_query=$fd_path/

	    ## select a directory under $fd_path
	    fd_list_dirs=$(fd --type d --hidden . $fd_path)

	    dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	    if [[ -d $dir_select ]]; then

		## dir_pwd_select is a directory
		BUFFER="cd ${dir_select}"
		zle vi-add-eol

	    fi

	fi

    fi

    zle -K viins
}

zle -N cd-nav-dirs


function cd-child ()
{
    ## search and select directories from cwd
    ## for drill down; apply for max-level=1
    ## press C-j again for no maximum level (cd-child-joint)

    ## clear command line
    zle kill-line

    ## set variables
    cd_function=1
    fzf_prompt='C'
    fd_path=$PWD
    fd_options='--max-depth=1'

    ## number of depth 1 subdirs
    fd_path_no_sub_dirs=$(fd --type directory --follow --max-depth 1 . $fd_path | wc -l)

    ## directory types; root, bodies and leaves
    if [[ $fd_path_no_sub_dirs -eq 0 ]]; then

	## dir is a leaf (contains no subdirs)
	printf "${fg_amber}@leaf${st_def}"
	sleep 0.5
	zle reset-prompt

    elif [[ $fd_path_no_sub_dirs -ge 1 ]]; then

	## dir is a body (contains subdirs)
	insert-item-fzf $fd_path $fd_options $fzf_prompt

	## place and execute 'cd'
	if [[ -z $fzf_output ]]; then

	    ## empty output (i.e. C-j)
	    cd-child-joint

	elif [[ -n $fzf_output ]]; then

	    BUFFER="cd $BUFFER" && zle accept-line

	    ## reset cd_function
	    cd_function=''

	fi

    fi
}

zle -N cd-child


function cd-child-joint ()
{
    ## search and select directories from cwd and deeper
    ## for drill down; no maximum level

    ## clear command line
    zle kill-line

    ## set variables
    cd_function=1
    fzf_prompt='C'
    fd_path=$PWD
    fd_options='--'

    ## number of subdirs
    fd_path_no_sub_dirs=$(fd --type directory --follow . $fd_path | wc -l)

    ## directory types; root, bodies and leaves
    if [[ $fd_path_no_sub_dirs -eq 0 ]]; then

	## dir is a leaf (contains no subdirs)
	printf "${fg_amber}@leaf${st_def}"
	sleep 0.5
	zle reset-prompt

    elif [[ $fd_path_no_sub_dirs -ge 1 ]]; then

	## dir is a body (contains subdirs)
	insert-item-fzf $fd_path $fd_options $fzf_prompt

	## place and execute 'cd'
	[[ -n $fzf_output ]] && BUFFER="cd $BUFFER" && zle accept-line

    fi

    ## reset cd_function
    cd_function=''
}

zle -N cd-child-joint


function cd-up ()
{
    ## directory types; root, bodies and leaves
    if [ "$(echo $PWD)" = "/" ]; then

	## dir is the root (/)
	printf "${fg_amber}@root${st_def}"
	sleep 0.5
	zle reset-prompt

    else

	## dir is not the root (/)
	## go to parent directory
	BUFFER="cd .."
	zle accept-line

    fi
}

zle -N cd-up


function cd-yazi ()
{
    #TODO DEV
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
	cd -- "$cwd"
    fi
    rm -rf -- "$tmp"
}


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
