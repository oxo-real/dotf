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

----------------------------------------------------------------------
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
======================================================================

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


cfg="$XDG_CONFIG_HOME"
zsh_config="$cfg/zsh"
zsh_function="$zsh_config/function"

for sh_function in $zsh_function/*.sh; do

    source $sh_function

done
