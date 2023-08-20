#
##
###
###          _
###  _______| |__   ___ _ ____   __
### |_  / __| '_ \ / _ \ '_ \ \ / /
###  / /\__ \ | | |  __/ | | \ V /
### /___|___/_| |_|\___|_| |_|\_/
###  _    _
### (_)><(_)
###
### .zshenv
### zsh environment variables
### 2019 - 2023  |  oxo
###
##
#


### no commands with output here ###

# path environment
### Zsh ties the PATH variable to a path array.
### https://zsh.sourceforge.io/Guide/zshguide02.html#l24

## retent redundancy; don't add to $path if it's there already
## -U will work both also on colon-separated arrays, like $PATH
typeset -U path PATH

## main path
### start from scratch
path=(/usr/bin /usr/local/bin /usr/local/sbin)

## custom shell symlinks
path=($HOME/.config/shln $path)


# fpath environment
fpath=($fpath $HOME/.config/zsh/completions)


# xdg environment

## configuration
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_CONFIG_HOME="$HOME/.config"

## data
export XDG_DATA_HOME="$HOME/.local/share"

## logs
export XDG_LOGS_HOME="$HOME/.logs"

## cache
export XDG_CACHE_HOME="$HOME/.cache"

# location of the history file
export HISTFILE="$XDG_LOGS_HOME/history/history"


# z shell environment

export DEFAULT_VI_MODE=viins
export KEYTIMEOUT=1

## debug prompt
## used by sh -x
export PS4=':${BASH_SOURCE[0]:-$0} $(printf '%4d%s' "${LINENO}") ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

## default applications
export COLORTERM='truecolor'
export BAT_THEME='base16-256'
export BROWSER='/usr/bin/qutebrowser'
export BROWSERCLI='/usr/bin/w3m'
## [Environment variables - delta](https://dandavison.github.io/delta/environment-variables.html)
export DELTA_FEATURES='+side-by-side'
#export EDITOR='/usr/bin/nvim'
export EDITOR="emacs"
#export EDITOR="emacsclient -c"
export OPENER='/usr/bin/xdg-open'
export MANPAGER="sh -c 'col --no-backspaces --spaces | env TERM=xterm bat --language man --style plain'"
export MANROFFOPT="-c"
export PAGER='/usr/bin/less'
#export PAGER='/usr/bin/less'
export READER='/usr/bin/zathura'
export SHELL='/usr/bin/zsh'
export TERMINAL='/usr/bin/alacritty'
export VIDEO='/usr/bin/mpv'
export VISUAL='emacs'
#export VISUAL='emacsclient -c -a emacs'
#export VISUAL='/usr/bin/nvim'

export GTK_USE_PORTAL=0


# fzf

## fzf default options
export FZF_DEFAULT_OPTS='--cycle --layout=reverse --info=inline --bind ctrl-u:clear-query --preview="tree -L 1 {}" --preview-window=:hidden --color=dark,prompt:#96cbfe,pointer:#ffffb6,spinner:#a8ff60'
## fzf completion trigger (default **)
export FZF_COMPLETION_TRIGGER='~~'


## signposts to config
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GPG_AGENT_INFO="1"	# https://wiki.archlinux.org/title/GnuPG#mutt
export GPG_TTY="$(tty)"
export LESSHISTFILE="$XDG_CONFIG_HOME/less/.lesshst"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuch_config"
#export SYSMAILCAP="$XDG_CONFIG_HOME/neomutt/mailcap"
#export TMSU_DB="$XDG_DATA_HOME/c/tag/.tmsu/db"
export USER_AGENT="$(head -n 1 $XDG_LOGS_HOME/network/user_agent/current)"
export VIMINIT="source $XDG_CONFIG_HOME/nvim/init.vim"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export APPNDIR="$XDG_CONFIG_HOME/shln"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export TEMPDIR="$XDG_CACHE_HOME/temp"
export TMPDIR="$XDG_CACHE_HOME/temp"  # for mktemp
export TESTDIR="$XDG_CACHE_HOME/test"
export TRASHDIR="$XDG_CACHE_HOME/trash"

## '< $file' behaviour
## prevent less writing lesshst to $HOME
## use verbose long prompt (-M)
## quit if file fits on screen (-F)
## display status column (-J)
## display raw control chars (-R)
## prevent clearing screen on exit (-X)
## define colors for error (Emk), search (Swk) & prompt (Pkw)
function lessr() {
   less -MFJRX -P '%f %l %L %PX' --mouse --use-color --color='Emk' --color='SWk' --color='Pkw' $1
}
export READNULLCMD=lessr

## same pager for man
#export MANPAGER=lessr
# with MANPAGER man gives error 3
# therefore done via alia alias

# color output

## see notes/cal for italic / inverse
export TERM='screen-256color'
## tmux colors
[ -n "$TMUX" ] && export 'TERM=tmux-256color'


# audio

export BEEP="$XDG_DATA_HOME/a/media/audio/sound/airbus/da.ogg"
export MUSICDIR="$XDG_DATA_HOME/a/media/audio/music"

# git status for __git_ps1

## unstaged (*), staged (+)
export GIT_PS1_SHOWDIRTYSTATE=1
## stashed ($)
export GIT_PS1_SHOWSTASHSTATE=1
## untracked (%)
export GIT_PS1_SHOWUNTRACKEDFILES=1
## behind (<), ahead (>), equal (=) to upstream
export GIT_PS1_SHOWUPSTREAM='auto'
export GIT_PS1_SHOWUPSTREAM=1
## color
export GIT_PS1_SHOWCOLORHINTS='true'
export GIT_PS1_SHOWCOLORHINTS=1
## ignored directories
export GIT_PS1_HIDE_IF_PWD_IGNORED=1


# colors

## zls colors
ZLS_COLORS=\
"no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:\
bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:\
lc=\e[:rm=m:tc=00:sp=00:ma=07:hi=00:du=00:\
*.tar=31:*.tgz=31:\
*.arj=31:*.taz=31:*.lzh=31:*.zip=31:\
*.z=31:*.Z=31:*.gz=31:*.deb=31:\
*.jpg=35:*.gif=35:*.bmp=35:*.ppm=35:\
*.tga=35:*.xbm=35:*.xpm=35:*.tif=35:\
*.mpg=01;35:*.avi=01;35:*.gl=01;37:*.dl=01;37:\
*.mp4=01;35:*.webm=01;35:*.mkv=01;35:\
*.mp3=36"
export ZlS_COLORS

## ls colors
LS_COLORS=\
"no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:\
bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:\
lc=\e[:\
*.tar=31:*.tgz=31:\
*.arj=31:*.taz=31:*.lzh=31:*.zip=31:\
*.z=31:*.Z=31:*.gz=31:*.deb=31:\
*.jpg=35:*.gif=35:*.bmp=35:*.ppm=35:\
*.tga=35:*.xbm=35:*.xpm=35:*.tif=35:\
*.mpg=01;35:*.avi=01;35:*.gl=01;37:*.dl=01;37:\
*.mp4=01;35:*.webm=01;35:*.mkv=01;35:\
*.mp3=36"
export LS_COLORS

## grep colors
### ms matching string
### mc is matching context
### sl selected lines
### cx selected context
### fn filename (when shown)
### ln line numbers (when shown)
### bn byte numbers (when shown)
### se separator
GREP_COLORS=\
'ms=01;34:\
mc=01;33:\
sl=:\
cx=:fn=35:\
ln=32:\
bn=32:\
se=36'
export GREP_COLORS
