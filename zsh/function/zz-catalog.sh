#! /usr/bin/env sh

# --------------------------------------------------------------------
# zz-catalog.sh


zsh_config_dir="$XDG_CONFIG_HOME/zsh"
zsh_catalog="$XDG_DATA_HOME/c/git/note/catalog/source/zsh"

# create source file for oxo note catalog
cat $zsh_config_dir/.zshrc > "$zsh_catalog"
cat $zsh_config_dir/function/*.sh >> "$zsh_catalog"
