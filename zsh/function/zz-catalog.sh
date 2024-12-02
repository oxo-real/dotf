#! /usr/bin/env sh


zsh_config_dir="$XDG_CONFIG_HOME/zsh"
zsh_catalog="$XDG_DATA_HOME/c/git/note/catalog/source/zsh"

# create source file for oxo note catalog
cat $XDG_CONFIG_HOME/zsh/.zshrc > "$zsh_catalog"
cat $XDG_CONFIG_HOME/zsh/function/*.sh >> "$zsh_catalog"
