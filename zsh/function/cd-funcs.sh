#! /usr/bin/env sh


function cd-nav-dirs ()
{
    # cd navigate directories with fzf

    ##  order   fd_path (no cycle):
    ### 1 S --0 $dir_stack
    ### 2 C --0 $PWD
    ### 3 H --0 $HOME
    ### 4 R --0 $ROOT

    ## change directory; select from dirstack
    get-dirstack

    fzf_prompt='S'

    ## add option qqq-quit-exit-cancel
    dir_stack=$(printf '%s\n%s' "$dir_stack" 'qqq-quit-exit-cancel')

    ## 1 change directory; select a directory from $dir_stack
    dir_stack_select_fzf=$(printf '%s' "$dir_stack" | fzf --prompt "$fzf_prompt ")

    if [[ $dir_stack_select_fzf =~ 'qqq*' ]]; then

	return 10

    elif [[ -d $dir_stack_select_fzf ]]; then

	## dir_select_fzf is an absolute directory
	## or child of the cwd

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

	## dir_select_fzf is no absolute directory
	## nor from cwd accessible relative directory
	## test if (relative) dir exist somewhere
	fd_path=$ROOT
	fzf_prompt='R'
	fd_pattern="$dir_stack_select_fzf"
	fzf_query="$fd_pattern"

	fd_list_dirs=$(fd --type d --hidden --full-path "$fd_pattern" $fd_path)

	## add option qqq-quit-exit-cancel
	fd_list_dirs=$(printf '%s\n%s' "$fd_list_dirs" 'qqq-quit-exit-cancel')

	dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	if [[ -d $dir_select ]]; then

	    ## dir_pwd_select is a directory
	    BUFFER="cd ${dir_select}"
	    zle vi-add-eol

	elif [[ ! -d $dir_select || -z $dir_select ]]; then

	    printf '%s directory not found\n' "$fzf_query"
	    # TODO printf '${fg_amber}%s${st_def} directory not found\n' "$fzf_query"
	    return 100

	fi

    elif [[ -z $dir_stack_select_fzf ]]; then

	## 2 change directory; select a directory under $PWD
	## cd-child offers similar functionality directly
	fd_path=$PWD
	fzf_prompt='C'
	fzf_query=$PWD/

	fd_list_dirs=$(fd --type d --hidden . $fd_path)

	## add option qqq-quit-exit-cancel
	fd_list_dirs=$(printf '%s\n%s' "$fd_list_dirs" 'qqq-quit-exit-cancel')

	dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	if [[ $dir_select =~ 'qqq*' ]]; then

	    return 10

	elif [[ -d $dir_select ]]; then

	    ## dir_pwd_select is a directory
	    BUFFER="cd ${dir_select}"
	    zle vi-add-eol

	elif [[ -z $dir_select ]]; then

	    ## 3 change directory; select a directory under $HOME
	    fd_path=$HOME
	    fzf_prompt='H'
	    fzf_query=$HOME/

	    fd_list_dirs=$(fd --type d --hidden . $fd_path)

	    ## add option qqq-quit-exit-cancel
	    fd_list_dirs=$(printf '%s\n%s' "$fd_list_dirs" 'qqq-quit-exit-cancel')

	    dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

	    if [[ $dir_select =~ 'qqq*' ]]; then

		return 10

	    elif [[ -d $dir_select ]]; then

		## dir_home_select is a directory
		BUFFER="cd $dir_select"
		zle vi-add-eol

	    else

		## 4 change directory; select a directory under $ROOT
		fd_path=$ROOT
		fzf_prompt='R'
		fzf_query=$ROOT

		fd_list_dirs=$(fd --type d --hidden . $fd_path)

		## add option qqq-quit-exit-cancel
		fd_list_dirs=$(printf '%s\n%s' "$fd_list_dirs" 'qqq-quit-exit-cancel')

		dir_select=$(printf '%s' "$fd_list_dirs" | fzf --prompt "$fzf_prompt " --query "$fzf_query")

		if [[ $dir_select =~ 'qqq*' ]]; then

		    return 10

		elif [[ -d $dir_select ]]; then

		    ## dir_home_select is a directory
		    BUFFER="cd $dir_select"
		    zle vi-add-eol

		else

		    return 10

		fi

	    fi

	fi

    fi

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
