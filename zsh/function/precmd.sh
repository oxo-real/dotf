function precmd ()
{
    ## precmd runs before each prompt
    ## and thus runs after each command execution

    exit_code=$?

    ## WARNING exit_code must be obtained at the start of the precmd
    ## otherwise there is probably interference with the commands
    ## from within precmd itself

    # get t1 for $time_exec (ns)
    t1_exec_ns=$(date +'%s%N')

    # get execution time (ms)
    ## prevent errors if empty t0_exec_ns (i.e. zsh (re)start)
    [[ -n $t0_exec_ns ]] && \
	time_exec_ms=$( echo "scale=0; ( $t1_exec_ns - $t0_exec_ns ) / 1000000 " | bc -l )

    ## time_exec prettyfied
    t_ex_pretty=$(printf '%s' "$time_exec_ms")
    t_ex_len=${#time_exec_ms}
    t_ex_ms=${time_exec_ms: -3}

    if [[ $t_ex_len -gt 3 ]]; then

	t_ex_secs=${time_exec_ms%???}

    else

	t_ex_secs=''

    fi

    ## prompt path color
    if [[ -w $PWD ]]; then

	### normal state (user write permissions)
	### [zsh: 13 Prompt Expansion](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html)
	### single quotes; wait with expansion until print
	local precmd_left='%F{blue}%B%~%f%b $(git-branch "%s") $(git-dirty "%s")'

    else

	### no write permission directory color (amber #ffbf00)
	### single quotes; wait with expansion until print
	local precmd_left='%F{#000000}%K{#ffbf00}%B %~ %b%k%f $(git-branch "%s") $(git-dirty "%s")'

    fi

    ### right side
    if 	[[ -n $t0_exec_ns ]]; then

	# histcounter prettyfied by offset
	hc=$(( HISTCMD - 1 + $hist_cmd_offset ))

	## set precmd_right based on exec_time and exit_code
	if [[ $exit_code -eq 0 ]]; then

	    if [[ -n $t_ex_secs ]]; then

		## we have an exec time > 1000 ms
		### single quotes; wait with expansion until print
		local precmd_right='$t_ex_secs%F{#696969}$t_ex_ms%f $hc %D{%H%M%S}'

	    else

		## we have an exec time < 1000 ms
		### single quotes; wait with expansion until print
		local precmd_right='%F{#696969}$t_ex_ms%f $hc %D{%H%M%S}'

	    fi

	else

	    ## exit code
	    if [[ -n $t_ex_secs ]]; then

		## we have a exec time > 1000 ms
		### single quotes; wait with expansion until print
		local precmd_right='$t_ex_secs%F{#696969}$t_ex_ms%f %F{#ff6c60}$hc%f %D{%H%M%S}'

	    else

		## we have an exec time < 1000 ms
		### single quotes; wait with expansion until print
		local precmd_right='%F{#696969}$t_ex_ms %F{#ff6c60}$hc%f %D{%H%M%S}'

	    fi

	fi

    else

	# no starttime detected
	# when starting zsh or enter an empty line
	### single quotes; wait with expansion until print
	local precmd_right='* %D{%H%M%S}'

    fi

    ## https://developerfacts.com/answer/2267155-what-does-sstringkf1bbkf-mean
    ## position, alignment and optional correction parameters
    local l_precmd_r=${#${(S%%)precmd_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}  ## errors with other excl_pttrn
    #local l_precmd_r=$(strlen $precmd_right)

    local l_precmd_corr=0

    local l_precmd_pad=$(( COLUMNS - l_precmd_r - l_precmd_corr ))

    ## print
    ## double quotes; expansion occurs here

    print -Pr "${(l:$l_precmd_pad:)}$precmd_right"
    print -Pr "$precmd_left"

    unset t0_exec_ns
}
