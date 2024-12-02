#! /usr/bin/env sh


# sourcing

## file pointers
fzf_tab="$cfg/fzf-tab/fzf-tab.zsh"
fzf_zsh="$cfg/fzf/.fzf.zsh"
text_appearance="$cfg/source/text_appearance"
zsh_alia="$zsh_config/alia"
zsh_completions="$zsh_config/completions/completion.zsh"
zsh_syntax_hl='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

## alia
[[ -f $zsh_alia ]] && source $zsh_alia

## text_appearance
[[ -f $text_appearance ]] && source $text_appearance

## zsh completions
[[ -f $zsh_completions ]] && source $zsh_completions
