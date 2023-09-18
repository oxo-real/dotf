#
##
###            _
###    _______| |__  _ __ ___
###   |_  / __| '_ \| '__/ __|
###  _ / /\__ \ | | | | | (__
### (_)___|___/_| |_|_|  \___|
###  _    _
### (_)><(_)
###
### .zshrc
### zsh runcom configuration
### 2019 - 2023  |  oxo
###
##
#


# file pointers

xcfh="$XDG_CONFIG_HOME"
fzf_tab="$xcfh/fzf-tab/fzf-tab.zsh"
fzf_zsh="$xcfh/fzf/.fzf.zsh"
git_prompt="$xcfh/zsh/git-prompt.sh"
#lf_cd="$XDG_CONFIG_HOME/lf/lfcd.sh"
zsh_alia="$xcfh/zsh/alia"
zsh_completions="$xcfh/zsh/completions/completion.zsh"
zsh_syntax_hl='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'


# sourcing

## alia (or aliasses)
[[ -f $zsh_alia ]] && source $zsh_alia
## zsh completions
[[ -f $zsh_completions ]] && source $zsh_completions
## lfcd load function
#[[ -f $lf_cd ]] && source $lf_cd


# shell parameters

autoload -U colors && colors
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

## vi keys
bindkey -v
## [zle - Backspace in zsh stuck - Unix & Linux Stack Exchange]
## (https://unix.stackexchange.com/questions/290392/backspace-in-zsh-stuck/290403#290403)
bindkey -v "^?" backward-delete-char
#bindkey -v "^H" backward-delete-char

# CAUTION! bindkey ^V is occupied -> find zsh keycodes with C-v $key;


# up-to-cursor match dependent $HISTFILE search

## man zshzle
## [zsh: 18 Zsh Line Editor](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#History-Control)
## man zshcontrib
## [zsh: 26 User Contributions](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#User-Contributions)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # up arrow
bindkey "^[[B" down-line-or-beginning-search # down arrow


# synthesize prompt (precmd, preexec, left and right prompt)

## define cursor styles
function __def_cursor()
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
function __set_cursor()
{
    case $KEYMAP in

        main | viins)
	    __def_cursor vertical-line_blink
	    ;;

        vicmd)
	    __def_cursor block_blink
	    ;;

        visual)
	    __def_cursor block_steady
	    ;;

	*)
	    __def_cursor underline_blink
	    ;;

    esac
}


function zle-keymap-select()
{
    #__set_ps1
    __set_cursor
    zle reset-prompt
}


function zle-line-init()
{
    zle -K $DEFAULT_VI_MODE
    #__set_ps1
    __set_cursor
    zle reset-prompt
}


function zle-line-finish()
{
    #__set_ps1
    __set_cursor
    zle reset-prompt
}


function git_dirty()
{
    git_status="$(git status 2> /dev/null)"
    if echo "${git_status}" | grep -c 'branch is ahead:' &> /dev/null; then printf "a"; fi
    if echo "${git_status}" | grep -c 'new file::'       &> /dev/null; then printf "+"; fi
    if echo "${git_status}" | grep -c 'modified:'        &> /dev/null; then printf "*"; fi

    if echo "${git_status}" | grep -c 'Changes to be committed:' &> /dev/null; then

	tobeco=$(git diff --cached --numstat | wc -l)
	#tobeco=$(git rev-list --count --all)
	printf 'c%s ' "$tobeco"

    fi

    if echo "${git_status}" | grep -c 'renamed:' &> /dev/null; then

	renamed=$(git status --porcelain &> /dev/null | grep '^R' | wc -l)
	printf 'r%s ' "$renamed"

    fi

    if echo "${git_status}" | grep -c 'new file:' &> /dev/null; then

	new=$(git status --porcelain &> /dev/null | grep '^A' | wc -l)
	printf '+%s ' "$new"

    fi

    if echo "${git_status}" | grep -c 'deleted:' &> /dev/null; then

	deleted=$(git status --porcelain &> /dev/null | grep '^.D' | wc -l)
	printf '-%s ' "$deleted"

    fi

    if echo "${git_status}" | grep -c 'Untracked files:' &> /dev/null; then

	untracked=$(git status --porcelain &> /dev/null | grep '^??' | wc -l)
	printf '?%s ' "$untracked"

    fi
}


function git_branch()
{
    # Long form
    git rev-parse --abbrev-ref HEAD 2> /dev/null
    # Short form
    # git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'
}


# precmd
## runs before each prompt
function precmd()
{
    # get t1 for $time_exec (ns)
    t1_exec=`date +%s%N`

    # get execution time (ms)
    ## prevent errors if empty t0_exec (i.e. zsh (re)start)
    [[ -n $t0_exec ]] && \
	time_exec=$( echo "scale=0; ( $t1_exec - $t0_exec ) / 1000000 " | bc -l )

    # time_exec prettyfied
    t_ex_pretty=$(printf "%4s" "$time_exec")

    # prompt path color
    if [[ -w $PWD ]]; then

	local precmd_left="%F{blue}%B%~%f%b %F{#ffffff}$(git_branch "%s")%f $(git_dirty "%s")"
	#local precmd_left="%F{blue}%B%~%f%b $(git_branch "[%s] ")"
	#local precmd_left="%F{blue}%B%~%f%b $(__git_ps1 "[%s] ")"

    else

	# no write permission directory color #ff73fd
	local precmd_left="%F{#ff73fd}%B%~%f%b $(git_branch "%s") $(git_dirty "%s")"

    fi

    ### right side
    if 	[[ -n $t0_exec ]]; then

	# histcounter prettyfied by +100k
	local precmd_right="$t_ex_pretty $((HISTCMD -1 +100000)) %D{%H%M%S}"
	#local precmd_right="$t_ex_pretty %! %D{%H%M%S}"
	#%! runs only inside session

    else

	local precmd_right="%D{%H%M%S}"

    fi

    ### position, alignment and correction parameters
    local ppl_corr=0
    local ppr_corr=0
    #local ppr_corr=0
    local precmd_left_length=$(( ${#${(S%%)precmd_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}+$ppl_corr ))
    local precmd_right_length=$(( ${#${(S%%)precmd_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}+$ppr_corr ))
    local num_filler_spaces=$((COLUMNS - precmd_right_length))

    ### print

    print -Pr "${(l:$num_filler_spaces:)}$precmd_right"
    print -Pr "$precmd_left"

    unset t0_exec
}


# strlen
## called by preexec
function strlen()
{
    FOO=$1
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN=${#${(S%%)FOO//$~zero/}}
    echo $LEN
}

# preexec
# run before each command execution
function preexec()
{
    # get t0 for $time_exec (ns)
    # not equal to (pretty) start_time!!
    t0_exec=`date +%s%N`

    start_time=$( date +"%H%M%S" )
    local len_right=$( strlen "$start_time" )
    len_right=$(( $len_right + 1 ))
    local right_start=$(( $COLUMNS - $len_right ))

    local len_cmd=$( strlen "$@" )
    local len_prompt=$( strlen "$PROMPT" )
    local len_left=$(( $len_cmd + $len_prompt ))

    RDATE="\033[${right_start}C ${start_time}"

    if [ $len_left -lt $right_start ]; then

        # no right prompt overwriting
        # we can move one line up
        echo -e "\033[1A${RDATE}"

    else

	echo -e "${RDATE}"

    fi
}


zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish


# left and right prompt

setopt PROMPT_SUBST

## left prompt
PS1="%(?..%F{magenta}%B%?%f%b)%# "

## right prompt
## commandID with running time
## TRAPALRM breaks fzf and zsh completion
#RPS1="%! %D{%H%M%S}"
#TMOUT=1
#TRAPALRM() {
#    zle reset-prompt
#}

## debug prompt
# PS4 set in zshenv

# history

## location of the history file
## set in .zshenv
#HISTFILE=$XDG_LOGS_HOME/history/history

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


# pwd, statistics and ls on chpwd
function chpwd()
{
    ## prompt path color
    if [[ -w $PWD ]]; then

	local left_bar="%F{blue}%B%~%f%b"

    else

	# no write permission directory color #ff73fd
	local left_bar="%F{#ff73fd}%B%~%f%b"

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
    echo

    ## testing alignment
    #print $COLUMNS $lb_length $bar_filler_spaces $rb_length
    ## end testing alignment

    ls -A
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
## --> see sway config


#>>>>>>>>>>>>>	function insert_application
# add (+=) application to cursor position (^q) (ctrl q)

function insert_pacmanqq()
{
    LBUFFER+="$(pacman -Qq | fzf)"
}

zle -N insert_pacmanqq
bindkey "^A" insert_pacmanqq


#>>>>>>>>>>>>>	function insert_application
# add (+=) application to cursor position (^a) (ctrl a)

function insert_appn()
{
    LBUFFER+="$(ls "$APPNDIR" | fzf)"
}

zle -N insert_appn
bindkey "^a" insert_appn


#>>>>>>>>>>>>>	function insert_date_time
# add (+=) current date and time to cursor position (^@) (ctrl @)

function insert_date_time()
{
    LBUFFER+="$(date +%Y%m%d_%H%M%S)"
}

zle -N insert_date_time
bindkey "^@" insert_date_time
# C-` also work (control backtick)


#>>>>>>>>>>>>>	function insert_epoch
# add (+=) epoch to cursor position (^#) (ctrl #)

function insert_epoch()
{
    LBUFFER+="$(date +%s)"
}

zle -N insert_epoch
bindkey "^e" insert_epoch


#>>>>>>>>>>>>>	function git_add_commit
# git add & commit shortcut (^q) (ctrl q)

function git_add_commit()
{
    BUFFER="git add . && git commit --gpg-sign=7f462acc -a -m '`date +%Y%m%d_%H%M%S` (local_update)'"
}

zle -N git_add_commit
bindkey "^q" git_add_commit


#>>>>>>>>>>>>>> function up_dir
# updir shortcut (^k) (ctrl k)

function up_dir()
{
    BUFFER="cd .."
    zle accept-line
}

zle -N up_dir
bindkey "^k" up_dir


#>>>>>>>>>>>>>> function last_dir
# last_dir shortcut (^h) (ctrl h)
## bash: 'cd -'

function last_dir()
{
    BUFFER="cd $OLDPWD"
    zle accept-line
}

zle -N last_dir
bindkey "^h" last_dir


#>>>>>>>>>>>>>> function ins_pwd
# insert $PWD inline
# Control+p

function ins_pwd()
{
    # select & kill
    zle select-in-blank-word
    zle kill-region

    CUTBUFFER="$PWD"
    zle vi-put-before
    #zle put-replace-selection

    unset CUTBUFFER
}

zle -N ins_pwd
bindkey '^p' ins_pwd


#>>>>>>>>>>>>>> function fzf_ins_dir
# fzf insert file or directory
# ^o pwd, ^f $HOME, ^g /

function fzf_ins_dir()
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

function fzf_ins_pwd()
{
    fzf_ins_dir "$PWD"
}

zle -N fzf_ins_pwd
bindkey "^o" fzf_ins_pwd


#>>>>>>>>>>>>>> function fzf_ins_home
# fzf insert file or directory (^f) (ctrl f)
# search from home

function fzf_ins_home()
{
    fzf_ins_dir "$HOME"
}

zle -N fzf_ins_home
bindkey "^f" fzf_ins_home


#>>>>>>>>>>>>>> function fzf_ins_root
# fzf insert file or directory (^g) (ctrl g)
# search from root

function fzf_ins_root()
{
    fzf_ins_dir '/'
}

zle -N fzf_ins_root
bindkey "^g" fzf_ins_root


#>>>>>>>>>>>>>> function sudo_toggle
# sudo-toggle (vicmd s)

function sudo_toggle()
{
    [[ -z $BUFFER ]] && zle up-history

    if [[ $BUFFER == sudo\ * ]]; then

	#already sudo; remove sudo
	BUFFER="${BUFFER#sudo }"

    else

	BUFFER="sudo $BUFFER" #add sudo

    fi

    zle -R $BUFFER #refresh
}

zle -N sudo_toggle #create widget
bindkey -M vicmd 's' sudo_toggle


#>>>>>>>>>>>>>> function histdel
# histdel
# Control+backspace
# [TODO]
#function histdel()
#{
#	export shiftbackspace=1
#	sh $XDG_DATA_HOME/c/git/code/tool/histdel
#}
#
#zle -N histdel
#bindkey '^H' histdel


#>>>>>>>>>>>>>> function foreground
# foreground
# Control+backspace

function foreground()
{
    fg;
}

zle -N foreground
bindkey '^Z' foreground


#>>>>>>>>>>>>>> function mountr
# mountr
# Control+slash

function mountr_widget()
{
    # inverted text to indicate widget call
    printf "\e[7m mountr \e[27m\n"

    sh $XDG_DATA_HOME/c/git/code/tool/mountr
    echo
    zle reset-prompt
}

zle -N mountr_widget
bindkey '^_' mountr_widget


#>>>>>>>>>>>>>> function lfcd
# lfcd
# Control+j
# function lfcd is by default externally sourced from:
# lf_cd="$XDG_CONFIG_HOME/lf/lfcd.sh"

function lfcd()
{
    # provide lfcd function inside a zsh shell environment
    tmp="$(mktemp)"

    # `command` is needed in case `lfcd` is aliased to `lf`
    # -last-dir-path is written into $tmp
    command lf -last-dir-path="$tmp" "$@"

    if [ -f "$tmp" ]; then

	# read last dir
	dir="$(command cat "$tmp")"
	# cleanup
        rm -f "$tmp"

	if [ -d "$dir" ]; then

	    if [ "$dir" != "$(pwd)" ]; then

		# inverted text to indicate widget call
		printf '\e[7m lfcd \e[27m %s\n' "$dir"

		#printf 'lfcd %s\n' "$dir"
		cd "$dir"

	    fi

        fi

    fi

    echo
    # TODO DEV
    # `zle reset-prompt` gives error
    # zle:38: widgets can only be called when ZLE is active
    # when called directly via cli (by typing: `lfcd`)
    zle reset-prompt
}

zle -N lfcd
bindkey '^j' lfcd
#bindkey -s '^j' 'lfcd\n'
#bindkey -s '^j' "lfcd\n"


# syntax highlighting
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f $zsh_syntax_hl ]] && source $zsh_syntax_hl


# base16-shell colorscheme
## https://github.com/chriskempson/base16-shell
BASE16_SHELL="$XDG_CONFIG_HOME/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"


# fzf
## https://github.com/junegunn/fzf#installation
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
[[ -f $fzf_tab ]] && source $fzf_tab

## fzf-tab-completions
## https://github.com/lincheney/fzf-tab-completion
#source $XDG_CONFIG_HOME/fzf-tab-completion/zsh/fzf-zsh-completion.sh

# clear current line (oxo bindkey note)  ## via vicmd; M > cc
