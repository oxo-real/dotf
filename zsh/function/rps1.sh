#! /usr/bin/env sh

# --------------------------------------------------------------------
# rps1.sh


strlen_sh="$XDG_CONFIG_HOME/zsh/function/strlen.sh"


## right side prompt (RPS1)
## shows running time without breaking menus (like fzf or zsh completion)

## no indentation for RPS1
ZLE_RPROMPT_INDENT=0


function calc-epoch ()
{
    epoch=$(date +'%s')
    ep_l=$(printf "$epoch" | cut -c 1-4)
    ep_r=$(printf "$epoch" | cut -c 5-)
}


## define what to display in RPS1
function calc-rps1 ()
{
    #TODO below TM_OUT threshold RPS1 shows irrelavant data
    calc-epoch
    source $strlen_sh

    ## weekday, daynum, epoch and time
    #weekday=$(date +'%u')
    #day_num=$(date +'%d')
    #rp='$weekday $day_num%F{#696969}$ep_l $ep_r%f %D{%H%M%S}'

    ## only time
    #rp='%D{%H%M%S}'

    ## elapsed time and current time
    elapsed_time_conversion
    rp="$et"' %D{%H%M%S}'

    ## length exit code in PS1
    if [[ "$exit_code" -gt '0' ]]; then

	l_exit=$(printf "$exit_code" | wc -c)

    else

	l_exit='0'

    fi

    ## length jobnumber in PS1 (1-9=1, 10-99=2, ...)
    l_jobs=$(jobs | wc -l)

    ## length PS1
    l_ps1=$(strlen $PS1)

    ## length rp
    l_rp=${#${(S%%)rp//(\%([KF1]|)\{*\}|\%[Bbkf])}}  ## errors with other excl_pttrn
    #l_rp=$(strlen $rp)

    ## correction factor
    #TODO DEV why and why 1?
    l_corr=1

    ## define RPS1 space padding
    ## so that RPS1 hides when start typing
    rp_padding=$(( COLUMNS - l_exit - l_jobs - l_ps1 - l_rp - l_corr ))

    ## set right prompt
    ## prints daynum epoch and time right side aligned
    RPS1="${(l:$rp_padding:)}$rp"

    ## control visability of RPS1
    [[ $RPS1_VIS != 'on' ]] && RPS1=''
}


elapsed_time_conversion ()
{
    ## timestamp
    ### t1_exec_ns exported from precmd
    ts=$(head -c 10 <<< "$t1_exec_ns")
    ## current time
    ct=$(date '+%s')
    ## elapsed time
    et=$(( ct - ts ))

    ## below threshold et is printed as elapsed time in seconds
    ## above threshold et is printed in '[d] hms' format
    ## dhms_th treshold in seconds
    dhms_th=600

    ## define dhms (with single digits for if statements)
    d="$(( et/60/60/24 ))"
    h="$(( et/60/60%24 ))"
    m="$(( et/60%60 ))"
    s="$(( et%60 ))"

    if [[ "$et" -gt "$dhms_th" ]]; then
	## less than one day passed
	## less than one hour passed
	## more than ten minutes passed

	## hms prettified with leading zeros
	h=$(printf '%02d' "$h")
	m=$(printf '%02d' "$m")
	s=$(printf '%02d' "$s")
	et="$h$m$s"

    elif [[ "$d" -gt 0 ]]; then
	## more than one day passed

	## hms prettified with leading zeros
	h=$(printf '%02d' "$h")
	m=$(printf '%02d' "$m")
	s=$(printf '%02d' "$s")
	et="$d $h$m$s"

    fi
}


function rp-redisplay ()
{
    ## updates RPS1 via TRAPALRM every TMOUT seconds
    ## disable from cli with: export RP_REDISPLAY='off'

    ## control auto redisplay of $RPS1
    [[ -z $RPS1_TRAP || $RPS1_TRAP == 'off' ]] && return

    fzf_active_tpgid=''
    curr_term_ppid=''
    fzf_active_ppid=''
    fzf_active_curr_term=''

    ## fzf active somewhere
    ## this gets all tpgid('s) of processes with fzf active
    fzf_active_tpgid=$(ps -C fzf -o tpgid=)
    #fzf_asw=$(ps -C fzf -o tpgid=)

    if [[ -n "$fzf_active_tpgid" ]]; then

	return
	### prevent interference with fzf in currently active terminal
	#curr_term_ppid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .pid')

	#IFS=$'\n'
	#for tpgid in $fzf_active_tpgid; do

	#    ## get ppid of current tpgid
	#    fzf_active_ppid=$(ps -g $tpgid -o ppid --no-headers | sort | head -n -1)

	#    ## current active terminal ppid is the same
	#    fzf_active_curr_term=$(printf '%s\n' "$fzf_active_ppid" | grep "$curr_term_ppid")

	#    if [[ -n "$fzf_active_curr_term" ]]; then

	#	## don't refresh rps1
	#	return

	#    fi

	#done

    fi

    ## only when $RPS1 exists and nothing is typed in buffer
    if [[ -z "$BUFFER" ]]; then

	   calc-rps1

	   ## prevent error on initial activation
	   ## when zle is not yet active
	   zle && { zle reset-prompt; zle -R }
	   #zle reset-prompt

    fi
}


function TRAPALRM ()
{
    rp-redisplay
}


## right side prompt (RPS1)
## TMOUT triggers the TRAPALRM
## RPS1 refresh rate (seconds)
TMOUT=3

## RPS1 initial activation
rp-redisplay
