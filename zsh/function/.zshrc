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
zsh_config="$cfg/zsh"
zsh_alia="$zsh_config/alia"
zsh_function="$zsh_config/function"
zsh_completions="$zsh_config/completions/completion.zsh"
zsh_syntax_hl='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'


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


zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish


## zsh functions
for zsh_function in $zsh_function/*; do

    source $zsh_function

done
