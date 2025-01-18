
# zsh completion

## man zshcompsys

## zstyle pattern template
## :completion:<function>:<completer>:<command>:<argument>:<tag>

## initialize completion
### load compinit
### U TODO
### z TODO
autoload -Uz compinit
### initialize compinit
### i ignores insecure files and directories
compinit -i

zmodload zsh/complist
zstyle ':completion:*' menu select
#zstyle ':completion:*' verbose yes

## include dotfiles
autoload -Uz compinit promptinit  ## DEV TODO again?
_comp_options+=(globdots)
promptinit
CASE_SENSITIVE='true'

## completion style based of 'default' zls_colors
## see zsh manual:
#@ http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
zstyle ':completion:*' list-colors $ZLS_COLORS

## ignore the /etc/hosts (which is mainly a blocklist) lookup for ssh
zstyle ':completion:*:ssh:*' hosts off
