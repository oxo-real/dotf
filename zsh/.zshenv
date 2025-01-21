#

###            _
###    _______| |__   ___ _ ____   __
###   |_  / __| '_ \ / _ \ '_ \ \ / /
###  _ / /\__ \ | | |  __/ | | \ V /
### (_)___|___/_| |_|\___|_| |_|\_/
###
###
###  # # # # # #
###       #
###  # # # # # #
###

: '
.zshenv
zsh environment variables
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
  n/a

# usage
  WARNING no commands with output here

# examples
  n/a

# '


# sourcing

## ZDOTDIR environment variable is sourced via etc_zsh_zshenv
## c c/git/note/linux/terminal/shell/zsh/etc_zsh_zshenv


# host

export HOSTNAME="$(head -n 1 /etc/hostname)"


# homes

export HOME="/home/$(logname)"
export ROOT='/'


# hist
## for history shell options (setopt) see zshrc

## (absolute!) location of the history file
export HISTFILE="$XDG_LOGS_HOME/history/history"

## maximum number of history events to save in the history file
export SAVEHIST=1000000

## maximum number of events stored in the internal history list
export HISTSIZE=1000000


# path environment

### Zsh ties the PATH environment variable to a path array.
### https://zsh.sourceforge.io/Guide/zshguide02.html#l24

## main path
### start from scratch
path=(
    /usr/bin
    /usr/local/bin
    /usr/local/sbin
    $HOME/.config/shln
)

## retent redundancy; don't add duplicates to $path
## -U will work both also on colon-separated arrays, like $PATH
typeset -U path

## expanding the path array into a space-separated list of
## unique existing directories
path=($^path(N-/))

## global scope (environment variable)
export PATH


# fpath environment

### fpath is the search path for function definitions

## add specific directories to fpath
fpath+=(
    $HOME/.config/zsh/completions
)

fpath=($^fpath(N-/))

export FPATH


# sway environment

## $XKB_DEFAULT_OPTIONS and $XDG_CURRENT_DESKTOP
## must be set before sway has been started
## for zsa moonlander xkb_options to work
export XKB_DEFAULT_OPTIONS='compose:ralt,shift:both_capslock'
export XDG_CURRENT_DESKTOP='sway'
export XCURSOR_SIZE=20


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


# z shell environment

## 24 bits colors
## easy define hex rgb colors with FHX and BHX
## in $cgcsft defined color names are available in zsh
cgcsft="$XDG_DATA_HOME/c/git/code/source/function/text_appearance"
[[ -f "$cgcsft" ]] && source "$cgcsft"

export DEFAULT_VI_MODE=viins
export KEYTIMEOUT=1

## RPS1 (right prompt)
### RPS1 visibility
export RPS1_VIS=on
### RPS1 auto redisplay
export RPS1_TRAP=on

## debug prompt (when using sh -x)
export PS4=':${BASH_SOURCE[0]:-$0} $(printf '%4d%s' "${LINENO}") ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

## default applications
export COLORTERM='truecolor'
export BAT_THEME='base16-256'
export BROWSER='qutebrowser'
export BROWSERCLI='w3m'
## [Environment variables - delta](https://dandavison.github.io/delta/environment-variables.html)
export DELTA_FEATURES='+side-by-side'
export EDITOR='emacs'
export OPENER='xdg-open'
export LESSHISTFILE='/dev/null'
export MANLESS='\ \$MAN_PN\ ?L∑%L\ .?pt%pt\%\ .[?lt%lt-?lb%lb]\ ..?e[EOF]\ .'
#export MANPAGER='less'
#export MANPAGER="nvim -c 'set ft=man' -"
#export MANPAGER="sh -c 'col --no-backspaces --spaces | bat --language man --style plain'"
export MANROFFOPT='-c'
export PAGER='less'
export GIT_PAGER="$PAGER"
export READER='zathura'
export SHELL='zsh'
export TERM='xterm-256color'
export TERMINAL='alacritty'
export TERM_BU='foot'
export VIDEO='mpv'
export VISUAL='emacs'

export GTK_USE_PORTAL=0

## ascii string
export ASCII=$(for (( i=32; i<127; i++ )) do; printf "\\$(printf %03o "$i")"; done)

## strftime format presets
export DT=+'%Y%m%d_%H%M%S'
export DTE=+'%Y%m%d_%H%M%S_%s'
export DTZWE=+'%Y%m%d_%H%M%S%z_%Z_%V_%s'

## permanently disable pwgn (vault)
#export PWGN_OFF=1

# fzf

## fzf default options
export FZF_DEFAULT_OPTS='--ansi --cycle --layout reverse --tiebreak length,begin,index --info inline:'∑=' --height ~25% --bind esc:cancel,ctrl-c:abort --scrollbar '' --no-unicode --color dark,fg:#999999,hl:#ffffff,hl+:#ffffff,bg+:#333333,info:#96cbfe,prompt:#96cbfe,pointer:#ffffd3,query:#999999,marker:#a8ff60,separator:#111111,spinner:#000000'
## fzf completion trigger (default **)
export FZF_COMPLETION_TRIGGER='~~'


# other signposts to config

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GPG_AGENT_INFO='1'	# https://wiki.archlinux.org/title/GnuPG#mutt
export GPG_TTY="$(tty)"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuch_config"
#export SYSMAILCAP="$XDG_CONFIG_HOME/neomutt/mailcap"
#export TMSU_DB="$XDG_DATA_HOME/c/tag/.tmsu/db"
export USER_AGENT="$(head -n 1 $XDG_LOGS_HOME/network/user_agent/current)"
# export VIMINIT="source $XDG_CONFIG_HOME/nvim/init.vim"
# export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"

export APPNDIR="$XDG_CONFIG_HOME/shln"
export DNLDDIR="$XDG_DATA_HOME/c/download"
export ROOTDIR='/'
export TEMPDIR="$XDG_CACHE_HOME/temp"
export TESTDIR="$XDG_CACHE_HOME/test"
export TMPDIR="$XDG_CACHE_HOME/temp"  # for mktemp
export TRASHDIR="$XDG_CACHE_HOME/trash"

## qt5 fix
#export QT_QPA_PLATFORMTHEME='qt5ct'
## qt6 fix
## solve flashing qutebrowser
## needed for obs (screencast pipewire
export QT_QPA_PLATFORMTHEME='qt6ct'

## wayland fix
export QT_QPA_PLATFORM='wayland'

## lessr
export READNULLCMD='read0cmd'


# audio and sound

export BEEP="$XDG_DATA_HOME/a/media/audio/sound/airbus/da.ogg"
export MUSICDIR="$XDG_DATA_HOME/a/media/audio/music"
export RES_MPV=360

# colors

## dircolors creates and export default LS_COLORS
### colors the ls command output
eval "$(dircolors)"
#eval "$(dircolors "$XDG_DATA_HOME"/c/git/note/linux/shell/color/etc_DIR_COLORS)"

## oxo added ls color definitions
defs_oxo='*.pdf=01;35'
LS_COLORS+="${defs_oxo}"

## eza colors
## man 5 eza_colors
## reset disables eza built-in color set entirely
EZA_COLORS='reset:'"$LS_COLORS"
export EZA_COLORS

## lf colors
## [Colors and Icons · gokcehan/lf Wiki · GitHub](https://github.com/gokcehan/lf/wiki/Colors-and-Icons)
## colors and icons file support replaced configuration method using environmental variables
#LF_COLORS="$LS_COLORS"
#export LF_COLORS

## zls colors
### color zsh/complist completion lists
#lc=\e[:\
defs_zls=\
"rc=m:\
tc=0:\
sp=0:\
ma=07:\
hi=00:\
du=00"
ZLS_COLORS="$LS_COLORS":"${defs_zls}"
export ZLS_COLORS


# zle settings

## prevent zsh from eating space before | or & after tab completion
## default ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&|'
export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;'
