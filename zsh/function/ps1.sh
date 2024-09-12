#! /usr/bin/env sh


function ps1 ()
{

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

}
