#! /usr/bin/env sh

# --------------------------------------------------------------------
# preexec.sh


function preexec ()
{
    ## runs before each command execution
    ## execution start time right side aligned (> 154550)

    # get t0 for $time_exec (ns)
    # not equal to (pretty) start_time!!
    t0_exec_ns=$(date +'%s%N')
    ### %1d at least one 0 in t0_epoch
    t0_epoch=$(printf "%1d\n" ${t0_exec_ns: 0 : -9})

    start_time_hms=$(date -d @$t0_epoch +'%H%M%S')
    start_time=$(printf '> %s' "$start_time_hms")

    local len_right_wo_corr=$(strlen "$start_time")
    local corr=1
    #local len_right=$(( $len_right_wo_corr ))
    local len_right=$(( $len_right_wo_corr + $corr ))
    local right_start=$(( $COLUMNS - $len_right ))

    local len_cmd=$(strlen "$@")
    local len_prompt=$(strlen "$PS1")
    local len_left=$(( $len_cmd + $len_prompt ))

    pre_exec_right="\e[${right_start}C ${start_time}"

    ## if end of $PROMPT lays left of first column of $pre_exec_right
    if [ $len_left -lt $right_start ]; then

	## then we have enough columns and we shift one line up
        echo -e "\e[1A${pre_exec_right}\e[0m"

    else

        # no upshift to prevent left prompt overwriting
	echo -e "${pre_exec_right}"

    fi
}
