#! /usr/bin/env sh

###
###   ___ ______ _  __      ___ __ __ _ _ __  _ __   ___ _ __
###  / _ \_  / _` | \ \ /\ / / '__/ _` | '_ \| '_ \ / _ \ '__|
### |  __// / (_| |  \ V  V /| | | (_| | |_) | |_) |  __/ |
###  \___/___\__,_|___\_/\_/ |_|  \__,_| .__/| .__/ \___|_|
###              |_____|               |_|   |_|
###
###  # # # # # #
###       #
###  # # # # # #
###

: '
eza_wrapper.sh
translate ls flags to eza
copyright (c) 2023 - 2024  |  oxo

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
add to alia:

if command -v eza >/dev/null; then

    alias ls="$XDG_CONFIG_HOME/eza/eza-wrapper.sh"

else

    alias ls="command ls $LS_OPTIONS"

fi

# usage
  n/a

# examples
  n/a

# notes
[Now moving from exa to eza fork. Wrapper script to give it nearly identical switches and appearance to ls. Also automatically adds --git switch when in a git repository. · GitHub]
(https://gist.github.com/eggbean/74db77c4f6404dd1f975bd6f048b86f8)

# '


## Change following to '0' for output to be like ls and '1' for eza features
# Don't list implied . and .. by default with -a
dot=1
# Show human readable file sizes by default
hru=1
# Show file sizes in decimal (1KB=1000 bytes) as opposed to binary units (1KiB=1024 bytes)
meb=0
# Don't show group column
fgp=0
# Don't show hardlinks column
lnk=0
# Show file git status automatically (can cause a slight delay in large repo trees)
git=1
# Show icons
ico=0
# Show column headers
hed=0
# Group directories first in long listing by default
gpd=1
# Colour always even when piping (can be disabled with -N switch when not wanted)
col=1

help()
{
    cat << EOF
  ${0##*/} options:
   -a  all
   -A  almost all
   -1  one file per line
   -x  list by lines, not columns
   -l  long listing format
   -G  display entries as a grid *
   -k  bytes
   -h  human readable file sizes
   -F  classify
   -R  recurse
   -r  reverse
   -d  don't list directory contents
   -D  directories only *
   -P  group directories first *
   -I  ignore [GLOBS]
   -i  show inodes
   -o  show octal permissions *
   -N  no colour *
   -S  sort by file size
   -t  sort by modified time
   -u  sort by accessed time
   -c  sort by created time *
   -X  sort by extension
   -M  time style [iso|long-iso|full-iso|relative] *
   -T  tree *
   -L  level [DEPTH] *
   -s  file system blocks
   -g  don't show/show file git status *
   -O  don't show/show icons *
   -n  ignore .gitignore files *
   -b  file sizes in binary/decimal (--si in ls)
   -Z  show each file's security context
   -@  extended attributes and sizes *

    * not used in ls
EOF
    exit
}

[[ $* =~ --help ]] && help

eza_opts=()

while getopts ':aAbtucSI:rkhnsXL:M:PNg1lFGRdDioOTxZ@' arg; do

    case $arg in

    a) (( dot == 1 )) && eza_opts+=(-a) || eza_opts+=(-a -a) ;;
    A) eza_opts+=(-a) ;;
    t) eza_opts+=(-s modified); ((++rev)) ;;
    u) eza_opts+=(-us accessed); ((++rev)) ;;
    c) eza_opts+=(-Us created); ((++rev)) ;;
    S) eza_opts+=(-s size); ((++rev)) ;;
    I) eza_opts+=(--ignore-glob="${OPTARG}") ;;
    r) ((++rev)) ;;
    k) ((--hru)) ;;
    h) ((++hru)) ;;
    n) eza_opts+=(--git-ignore) ;;
    s) eza_opts+=(-S) ;;
    X) eza_opts+=(-s extension) ;;
    L) eza_opts+=(--level="${OPTARG}") ;;
    o) eza_opts+=(--octal-permissions) ;;
    M) eza_opts+=(--time-style="${OPTARG}") ;;
    P) ((++gpd)) ;;
    N) ((++nco)) ;;
    g) ((++git)) ;;
    O) ((++ico)) ;;
    b) ((--meb)) ;;
    1|l|F|G|R|d|D|i|T|x|Z|@) eza_opts+=(-"$arg") ;;
    :) printf "%s: -%s switch requires a value\n" "${0##*/}" "${OPTARG}" >&2; exit 1
       ;;
    *) printf "Error: %s\n       --help for help\n" "${0##*/}" >&2; exit 1
       ;;

    esac

done

shift "$((OPTIND - 1))"

(( rev == 1 )) && eza_opts+=(-r)
(( fgp == 0 )) && eza_opts+=(-g)
(( lnk == 0 )) && eza_opts+=(-H)
(( hru <= 0 )) && eza_opts+=(-B)
(( hed == 1 )) && eza_opts+=(-h)
(( meb == 0 && hru > 0 )) && eza_opts+=(-b)
(( col == 1 )) && eza_opts+=(--color=always) || eza_opts+=(--color=auto)
(( nco == 1 )) && eza_opts+=(--color=never)
(( gpd >= 1 )) && eza_opts+=(--group-directories-first)
(( ico == 1 )) && eza_opts+=(--icons)
(( git == 1 )) && \
  [[ $(git -C ${*:-.} rev-parse --is-inside-work-tree) == true ]] 2>/dev/null && eza_opts+=(--git)

eza "${eza_opts[@]}" "$@"
