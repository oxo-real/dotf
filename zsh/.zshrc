#! /usr/bin/env sh

###            _
###    _______| |__  _ __ ___
###   |_  / __| '_ \| '__/ __|
###  _ / /\__ \ | | | | | (__
### (_)___|___/_| |_|_|  \___|
###
###
###  # # # # # #
###       #
###  # # # # # #
###

: '
.zshrc
zsh runcom configuration
copyright (c) 2019 - 2024  |  oxo

GNU GPLv3 GENERAL PUBLIC LICENSE
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
https://www.gnu.org/licenses/gpl-3.0.txt

@oxo@qoto.org


# dependencies
  base16-shell, fd, fzf, git
  $XDG_CONFIG_HOME/i3blocks
  $XDG_CONFIG_HOME/sway
  $XDG_CONFIG_HOME/zsh/alia
  $XDG_CONFIG_HOME/zsh/completions
  $XDG_CONFIG_HOME/source/text_appearance
  /usr/share/zsh/plugins/zsh-syntax-highlighting

# usage
  n/a

# examples
  n/a

# '


# file pointers

cfg="$XDG_CONFIG_HOME"
fzf_tab="$cfg/fzf-tab/fzf-tab.zsh"
fzf_zsh="$cfg/fzf/.fzf.zsh"
text_appearance="$cfg/source/text_appearance"
zsh_alia="$cfg/zsh/alia"
zsh_completions="$cfg/zsh/completions/completion.zsh"
zsh_syntax_hl='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

hist_cmd_offset=100000


# sourcing

## alia
[[ -f $zsh_alia ]] && source $zsh_alia
## text_appearance
[[ -f $text_appearance ]] && source $text_appearance
## zsh completions
[[ -f $zsh_completions ]] && source $zsh_completions


# shell parameters
autoload -U colors; colors
setopt auto_pushd


# fix the workings of important keys

## get SIGTERM string via `cat` and
## pressing the targeted key there

## backspace key in vicmd
### -a select vicmd keymap
bindkey -a "^?" backward-delete-char
## delete key in vicmd
bindkey -a "^[[3~" delete-char
## delete key in viins
### -M select keymap
bindkey -M viins "^[[3~" delete-char

## select viins keymap and bind it to main
bindkey -v

## add backspace (key sequence "^?") to main keymap
bindkey -v "^?" backward-delete-char

## inline history search
## NOTICE works also from vicmd with j and k (recommended)
### up arrow
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
### down arrow
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search


# synthesize prompt (precmd, preexec, left and right prompt)

## define cursor styles
function def-cursor()
{
    local style

    case $1 in

        reset)
	    # to default
	    style=0
	    ;;

	block_blink)
	    # default
	    style=1
	    ;;

	block_steady)
	    style=2
	    ;;

	underline_blink)
	    style=3
	    ;;

	underline_steady)
	    style=4
	    ;;

	vertical-line_blink)
	    style=5
	    ;;

	vertical-line_steady)
	    style=6
	    ;;

	*)
	    style=0
	    ;;

    esac

    ### define cursor
    [ $style -ge 0 ] && echo -n "\e[${style} q"
}


## define text style with select & paste
zle_highlight=(\
	       isearch:fg=#bbbbbb,bg=#000000 \
		   region:fg=#000000,bg=#555555 \
		   special:fg=#bbbbbb,bg=#000000 \
		   suffix:fg=#bbbbbb,bg=#000000 \
		   paste:fg=#bbbbbb,bg=#000000
)


## set cursor styles
function set-cursor()
{
    case $KEYMAP in

        main | viins)
	    def-cursor vertical-line_blink
	    ;;

        vicmd)
	    def-cursor block_blink
	    ;;

        visual)
	    def-cursor block_steady
	    ;;

	*)
	    def-cursor underline_blink
	    ;;

    esac
}


function zle-keymap-select()
{
    ## set_ps1
    set-cursor
    zle reset-prompt
}


function zle-line-init()
{
    zle -K $DEFAULT_VI_MODE
    ## set_ps1
    set-cursor
    zle reset-prompt
}


function zle-line-finish()
{
    ## set_ps1
    set-cursor
    zle reset-prompt
}


function git-branch()
{
    # Long form
    branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    # Short form
    # git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'

    git_status="$(git status 2> /dev/null)"

    if echo "${git_status}" | grep -c 'working tree clean' > /dev/null 2>&1; then

	## up-to-date branch (default grey)
	print "%F{#bbbbbb}$branch%f"

    else

	## changed branch (amber)
	print "%F{#ffbf00}$branch%f"

    fi
}


function git-dirty()
{
    ## [Git - git-status Documentation](https://git-scm.com/docs/git-status#_short_format)
    # a ahead
    # b behind
    # c to be committed
    # + new
    # - deleted
    # m modified
    # r renamed
    # ? untracked

    # instead of vcs_info
    # [zsh: 26 User Contributions](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#vcs_005finfo-Configuration)

    git_status="$(git status 2> /dev/null)"

    if echo "${git_status}" | grep -c 'branch is ahead' > /dev/null 2>&1; then

	ahead=$(git status | grep 'branch is ahead' | awk '{print $8}')
	printf 'a%s ' "$ahead"

    fi

    if echo "${git_status}" | grep -c 'branch is behind' > /dev/null 2>&1; then

	behind=$(git status | grep 'branch is behind' | awk '{print $8}')
	printf 'b%s ' "$behind"

    fi

    if echo "${git_status}" | grep -c 'new file:' > /dev/null 2>&1; then

	new=$(git status --porcelain > /dev/null 2>&1 | grep '^A\|^.A' | wc -l)
	printf "${fg_green}+%s${st_def} " "$new"

    fi

    if echo "${git_status}" | grep -c 'deleted:' > /dev/null 2>&1; then

	deleted=$(git status --porcelain > /dev/null 2>&1 | grep '^D\|^.D' | wc -l)
	printf "${fg_red}-%s${st_def} " "$deleted"

    fi

    if echo "${git_status}" | grep -c 'modified:' > /dev/null 2>&1; then

	modified=$(git status --porcelain > /dev/null 2>&1 | grep '^M\|^ M' | wc -l)
	printf 'm%s ' "$modified"

    fi

    if echo "${git_status}" | grep -c 'renamed:' > /dev/null 2>&1; then

	renamed=$(git status --porcelain > /dev/null 2>&1 | grep '^R\|^.R' | wc -l)
	printf 'r%s ' "$renamed"

    fi

    if echo "${git_status}" | grep -c 'Changes to be committed:' > /dev/null 2>&1; then

	tobeco=$(git diff --cached --numstat | wc -l)
	#tobeco=$(git rev-list --count --all)
	printf "${st_rev}c%s${st_def} " "$tobeco"

    fi

   if echo "${git_status}" | grep -c 'Untracked files:' > /dev/null 2>&1; then

	untracked=$(git status --porcelain > /dev/null 2>&1 | grep '^??' | wc -l)
	printf "${bg_red}${fg_black}?%s${st_def} " "$untracked"

    fi
}


# strlen
## called by preexec

function strlen()
{
    # calculate string length
    ## original
    arg=$1
    #local excl_pttrn='%([KF1]|)([BSUbfksu]|([FB]|){*})' ## errors
    #local excl_pttrn='%([BSUbfksu]|([FK]|){*})'
    local excl_pttrn='%([KF1]|)({*\}|[Bbkf])}'
    #local excl_pattrn='%([BSUbfksu]|([FB]|){*})'
    ## ~excl_pttrn ensures that excl_pttrn,
    ##  is treated as a pattern rather than as a plain string
    ## ${(S%%)arg//$~excl_pttrn/} matches ${arg//pattern/repl}
    ## S makes matching non-greedy shortest possible match
    ## repl is empty, basically removing the shorteest possible match
    local length=${#${(S%%)arg//$~excl_pttrn/}}
    echo $length
}

## alternative strlen fuction
## https://github.com/romkatv/powerlevel10k/blob/master/internal/p10k.zsh
: '
This function, strlen, calculates the length of a given string in bash.
It uses a loop to double the size of a variable y, until it is larger
than the length of the string.
Then it repeatedly halves y and checks if the substring of the
input string from 0 to y is equal to y.
If it is, it sets x to y and repeats the process until
it finds the length of the string.

# '
function xstrlen()
{
    # calculate $1 string length
    ## alternative

    ## initialize variables
    ## y is the length of $1
    local -i x y=${#1} m

    if (( y )); then

	# loop until y is larger than the length of the string
	## the condition is checking if the first argument passed
	## to the command is less than or equal to 1, and if it is not, the loop will exit
	while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do

            # double the size of y
	    x=y
	    (( y *= 2 ))

	done

        # binary search to find the length of the string
	while (( y > x + 1 )); do

	    ## calculate the midpoint of the range x to y
	    (( m = x + (y - x) / 2 ))
	    ## check if the length of the string is equal to the
	    ## midpoint m. If it is, then the length of the string is m
	    (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))

	done

    fi

    echo $x
}


# preexec

## runs before each command execution
## execution start time right side aligned (> 154550)
function preexec()
{
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


# precmd

## precmd runs before each prompt
## and thus runs after each command execution
function precmd()
{
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
	local precmd_left='%F{#000000}%K{#ffbf00}%B%~%b%k%f $(git-branch "%s") $(git-dirty "%s")'

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


zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish


# prompt

## prompt is PS1 (left side) and RPS1 (right side)
## see: note zsh oxo_prompt for explanation of all the prompt items
setopt PROMPT_SUBST

## left side prompt (PS1)
## defaults to only '%' (lights out phylosophy)

## ternary expressions %(expr.true.false)
## for exit code (?) and background jobs (j)
## [zsh: 13 Prompt Expansion](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts)
[[ $(host) != "$HOSTNAME" ]] && \
    PS1="%(?..%F{#ff6c60}%?%f)%(1j.%F{#4aa5fd}%K{#333333}%B%j%b%k%f.)%F{#000000}%K{#cccccc}%n@%m%k%f%(!.%F{#ffbf00}%B#%b%f.%%) " || \
    PS1="%(?..%F{#ff6c60}%?%f)%(1j.%F{#4aa5fd}%K{#333333}%B%j%b%k%f.)%(!.%F{#ffbf00}%B#%b%f.%%) "

## right side prompt (RPS1)
## shows running time without breaking menus (like fzf or zsh completion)

## no indentation for RPS1
ZLE_RPROMPT_INDENT=0

## define what to display in RPS1
calc-epoch()
{
    epoch=$(date +'%s')
    ep_l=$(printf "$epoch" | cut -c 1-4)
    ep_r=$(printf "$epoch" | cut -c 5-)
}

calc-rps1()
{
    calc-epoch

    day_num=$(date +'%d')
    rp='$day_num%F{#696969}$ep_l $ep_r%f %D{%H%M%S}'

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

rp-redisplay()
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

TRAPALRM()
{
    rp-redisplay
}

## TMOUT triggers the TRAPALRM
## RPS1 refresh rate (seconds)
TMOUT=3

## initial activation
rp-redisplay

## debug prompt (PS4)
## set in zshenv


# history

## location of the history file
## HISTFILE set in .zshenv

## maximum number of history events to save in the history file
SAVEHIST=1000000

## maximum number of events stored in the internal history list
HISTSIZE=1000000

## when trimming history file, first trim from duplicate entries
setopt HIST_EXPIRE_DUPS_FIRST

## prefix a command with a space keeps it out of history
setopt HIST_IGNORE_SPACE

## remove superfluous blanks
setopt HIST_REDUCE_BLANKS

## This option both imports new commands from the history file,
## and also causes your typed commands to be appended to the history file.
## The latter is like specifying INC_APPEND_HISTORY,
## which should be turned off if this option is in effect.
## The history lines are also output with timestamps ala EXTENDED_HISTORY.
setopt SHARE_HISTORY

## (multiple parallel) zsh sessions will (all) append their history to the
## history file
#setopt APPEND_HISTORY

## add commands to history file in realtime, instead of when shell exits
## comment out if SHARE_HISTORY is active
#setopt INC_APPEND_HISTORY

## command execution time is written after command is finished
## therefore history entry is available no sooner than after command execution
#setopt INC_APPEND_HISTORY_TIME

## add epoch time and execution time data in history
## comment out if SHARE_HISTORY is active
###setopt EXTENDED_HISTORY


# pwd, statistics and ls when cwd changes
function chpwd()
{
    ## prompt path color
    if [[ -w $PWD ]]; then

	local left_bar="%F{blue}%B%~%f%b"

    else

	# no write permission directory color #ffbf00
	local left_bar="%F{#000000}%K{#ffbf00}%B%~%b%k%f"

    fi

    ## directory count
    d_cnt=$(find . -maxdepth 1 -type d | tail -n +2 | wc -l)
    ## hidden directory count
    dh_cnt=$(find . -maxdepth 1 -type d -name '.*' | tail -n +2 | wc -l)
    ## visible directory count
    dv_cnt=$((d_cnt-dh_cnt))

    ## file count
    f_cnt=$(find . -maxdepth 1 -type f | wc -l)
    ## hidden file count
    fh_cnt=$(find . -maxdepth 1 -type f -name '.*' | wc -l)
    ## visible file count
    fv_cnt=$((f_cnt-fh_cnt))

    ## symlink count
    l_cnt=$(find . -maxdepth 1 -type l | wc -l)
    ## hidden symlink count
    lh_cnt=$(find . -maxdepth 1 -type l -name '.*' | wc -l)
    ## visible symlink count
    lv_cnt=$((l_cnt-lh_cnt))

    ## total item count
    ti_cnt=$((d_cnt+f_cnt+l_cnt))

    ## right bar
    ### sigma
    rb1=$(printf "\e[1;90m∑\e[0m")
    ### total count
    rb2=$(printf "\e[1;90m $ti_cnt \e[0m")
    ### directories
    rb3=$(printf "\e[1;94;100m $dv_cnt.$dh_cnt \e[0m")
    ### files
    rb4=$(printf "\e[0;39;49m $fv_cnt.$fh_cnt \e[0m")
    ### symlinks
    rb5=$(printf "\e[1;36;100m $lv_cnt.$lh_cnt \e[0m")

    ### synthesized
    right_bar=$(printf $rb1$rb2$rb3$rb4$rb5)

    ## position, alignment and correction parameters
    ### alacritty
    local lb_corr=0
    local rb_corr=-66
    local lb_length=$(( ${#${(S%%)left_bar//(\%([KF1]|)\{*\}|\%[Bbkf])}}+$lb_corr ))
    local rb_length=$(( ${#${(S%%)right_bar//(\%([KF1]|)\{*\}|\%[Bbkf])}}+rb_corr ))
    local bar_filler_spaces=$((COLUMNS - lb_length - rb_length ))

    print -Pr "$left_bar${(l:$bar_filler_spaces:)}$right_bar"
    #echo

    ## testing alignment
    #print $COLUMNS $lb_length $bar_filler_spaces $rb_length
    ## end testing alignment

    # NOTICE presumes ls alias with eza_wrapper.sh
    ls -A

    #eza --all --group-directories-first
    #ls -A
}


#~~~~~~~~~~~~~~~~~~~~~~~#
#  KEYBOARD SHORTCUTS	#
#~~~~~~~~~~~~~~~~~~~~~~~#

# for info on zsh keybindings:
# showkey --scancodes
# bindkey -l (zsh keymaps)
# bindkey -M <keymap>
# man zshzle
# zsh -f /usr/share/zsh/functions/Misc/zkbd
# find keycode in zsh terminal with ctrl-v and then the combo


## C-@  insert_date_time
## C-e  insert_epoch
## C-q  git_add_commit
## C-k  up_dir
## C-h  last_dir
## C-p  ins_pwd
## C-f  fzf_ins_home
## C-g  fzf_ins_root
## C-a  insert application
## C-z  foreground
## C-/  mountr_widget
## C-_  mountr_widget
## vicmd s  sudo_toggle


# spawn terminal into cwd
## M-S-Return
## --> see sway config


: '
#>>>>>>>>>>>>>	function insert_application
# add (+=) application to cursor position (^A) (ctrl-shift-A)

function insert-pacmanqq()
{
    #TODO escape code error
    LBUFFER+="$(pacman -Qq | fzf)"
}

zle -N insert-pacmanqq
#bindkey "^A" insert-pacmanqq
# '


#>>>>>>>>>>>>>	function insert_application
# add (+=) application to cursor position (^a) (ctrl a)

function insert-appn()
{
    #TODO escape code error
    LBUFFER+="$(ls "$APPNDIR" | fzf)"
}

zle -N insert-appn
bindkey "^a" insert-appn


#>>>>>>>>>>>>>	function insert_date_time
# add (+=) current date and time to cursor position (^@) (ctrl @)
# compact readable form of iso8601
function insert-date-time()
{
    LBUFFER+="$(date +%Y%m%d_%H%M%S)"
}

zle -N insert-date-time
bindkey "^@" insert-date-time
# C-` also works (control backtick) #DEV use for wl-copy date_time


#>>>>>>>>>>>>>	function insert_epoch
# add (+=) epoch to cursor position (^#) (ctrl #)

function insert-epoch()
{
    LBUFFER+="$(date +%s)"
}

zle -N insert-epoch
bindkey "^e" insert-epoch


#>>>>>>>>>>>>>	function git_add_commit
# git add & commit shortcut (^q) (ctrl q)

function git-add-commit()
{
    BUFFER="git add . && git commit --gpg-sign=7f462acc -a -m '`date +%Y%m%d_%H%M%S` (local_update)'"
}

zle -N git-add-commit
bindkey "^q" git-add-commit


#>>>>>>>>>>>>>> function up_dir
# updir shortcut (^k) (ctrl k)

function up-dir()
{
    BUFFER="cd .."
    zle accept-line
}

zle -N up-dir
bindkey "^k" up-dir


#>>>>>>>>>>>>>> function last_dir
# last_dir shortcut (^h) (ctrl h)
## bash: 'cd -'

function last-dir()
{
    BUFFER="cd $OLDPWD"
    zle accept-line
}

zle -N last-dir
bindkey "^h" last-dir


#>>>>>>>>>>>>>> function ins_pwd
# insert $PWD inline
# Control+p

function ins-pwd()
{
    # select & kill
    zle select-in-blank-word
    zle kill-region

    CUTBUFFER="$PWD"
    zle vi-put-before
    #zle put-replace-selection

    unset CUTBUFFER
}

zle -N ins-pwd
bindkey '^p' ins-pwd


#>>>>>>>>>>>>>> function fzf_ins_dir
# fzf insert file or directory
# ^o pwd, ^f $HOME, ^g /

function fzf-ins-dir()
{
    root_dir="$1"

    # select & kill
    zle select-in-blank-word
    zle kill-region
    input="$CUTBUFFER"
    [[ -n "$input" ]] && \
	fzf_input="$input" || \
	    fzf_input="$root_dir"

    # fzf query
    ## follow symlinks
    ## ignore from $XDG_CONFIG_HOME/fd/ignore
    ## include hidden files
    ## awk creates space separated results
    fzf_output="$(fd --follow --ignore --hidden \
      --ignore-file "$XDG_CONFIG_HOME/fd/ignore" . "$root_dir" | \
      fzf -m --query=`printf "$fzf_input"` --height=20% | awk NF=1 OFS=' ' ORS=' ')"

    ## invalidate the current zle display in preparation for output
    ## prevent loosing visibility of entered characters before fzf started
    zle -I

    # analyze fzf output
    [[ -n "$fzf_output" ]] && \
    	CUTBUFFER="$fzf_output" || \
    	    CUTBUFFER="$input"

    # replace selection
    zle vi-put-before
    #zle put-replace-selection

    unset CUTBUFFER
    unset fzf_input
    unset input
}


#>>>>>>>>>>>>>> function fzf_ins_pwd
# fzf insert file or directory (^f) (ctrl f)
# search from current directory and below

function fzf-ins-pwd()
{
    fzf-ins-dir "$PWD"
}

zle -N fzf-ins-pwd
bindkey "^l" fzf-ins-pwd

## default C-l was clear-screen (form feed); is now C-o
bindkey "^o" clear-screen


#>>>>>>>>>>>>>> function fzf_ins_home
# fzf insert file or directory (^f) (ctrl f)
# search from home

function fzf-ins-home()
{
    fzf-ins-dir "$HOME"
}

zle -N fzf-ins-home
bindkey "^f" fzf-ins-home


#>>>>>>>>>>>>>> function fzf_ins_root
# fzf insert file or directory (^g) (ctrl g)
# search from root

function fzf-ins-root()
{
    fzf-ins-dir '/'
}

zle -N fzf-ins-root
bindkey "^g" fzf-ins-root


#>>>>>>>>>>>>>> function sudo_toggle
# sudo-toggle (vicmd s)

function sudo-toggle()
{
    [[ -z $BUFFER ]] && zle up-history

    if [[ $BUFFER == sudo\ * ]]; then

	# already sudo; remove sudo
	BUFFER="${BUFFER#sudo }"

    else

	BUFFER="sudo $BUFFER"  ## add sudo

    fi

    zle -R $BUFFER  ## refresh
}

zle -N sudo-toggle  ## create widget
bindkey -M vicmd 's' sudo-toggle


#>>>>>>>>>>>>>> function sh-x_toggle
# sh-x_toggle (vicmd q)

function sh-x-toggle()
{
    [[ -z $BUFFER ]] && zle up-history

    if [[ $BUFFER == sh\ -x\ * ]]; then

	## replace sh -x with sh
	BUFFER="${BUFFER/sh -x /sh }"
	# remove sh -x
	#BUFFER="${BUFFER#sh -x }"

    elif [[ $BUFFER == sh\ * ]]; then

	## add -x to sh
	BUFFER="${BUFFER/sh /sh -x }"

    else

	## add sh -x
	BUFFER="sh -x $BUFFER"

    fi

    zle -R $BUFFER  ## refresh
}

zle -N sh-x-toggle  ## create widget
bindkey -M vicmd 'q' sh-x-toggle


#>>>>>>>>>>>>>> function foreground
# foreground
# Control+backspace

function foreground()
{
    fg;
}

zle -N foreground
bindkey '^Z' foreground


#>>>>>>>>>>>>>> function lfcd
# lfcd
# Control+j

function lfcd()
{
    # for precmd:
    # get t0 for $time_exec (ns)
    t0_exec_ns=$(date +'%s%N')

    printf "${st_inv}lfcd${st_dev}\n"

    cd "$(command lf -print-last-dir "$@")"

    precmd

    # `zle reset-prompt` gives error
    # when called directly via cli (by typing: `lfcd`)
    # [zsh zle - ZSH on 10.9: widgets can only be called when ZLE is active - Stack Overflow](https://stackoverflow.com/questions/20357441/zsh-on-10-9-widgets-can-only-be-called-when-zle-is-active)
    # solved with:
    zle && { zle reset-prompt; zle -R }
    #zle reset-prompt
}

zle -N lfcd
bindkey "^j" lfcd


# syntax highlighting
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f $zsh_syntax_hl ]] && source $zsh_syntax_hl


# base16-shell colorscheme
## https://github.com/chriskempson/base16-shell

## source profile_helper
BASE16_SHELL="$XDG_CONFIG_HOME/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    source "$BASE16_SHELL/profile_helper.sh"

## set base16_shell colorscheme
base16_irblack


# fzf

## https://github.com/junegunn/fzf#installation
## WARNING path is modified here
[[ -f $fzf_zsh ]] && source $fzf_zsh

# $fzf_zsh
# sources:
# $XDG_CONFIG_HOME/fzf/.fzf/shell/key-bindings.zsh
# which defines keybindings:
# CTRL-T - Paste the selected file path(s) into the command line
# ALT-C - cd into the selected directory
# CTRL-R - Paste the selected command from history into the command line

# $XDG_CONFIG_HOME/zsh/.zshenv
# defines:
# FZF_DEFAULT_OPS environment variable defines fzf default options

## fzf-tab
## https://github.com/Aloxaf/fzf-tab
## WARNING fpath is modified here
[[ -f $fzf_tab ]] && source $fzf_tab

## fzf-tab-completions
## https://github.com/lincheney/fzf-tab-completion
#source $XDG_CONFIG_HOME/fzf-tab-completion/zsh/fzf-zsh-completion.sh

: '
# additional notes on keybindings (oxo spicules)
bindkey -M vicmd 'cc'  ## change current line (clear > viins)
bindkey escape sequence: C-v $key (C-v ESC -> ^[)
# '
