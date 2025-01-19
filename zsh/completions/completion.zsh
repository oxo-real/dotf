
# zsh completion

## man zshcompsys



# initialize completion
## To initialize the system, the function compinit should be in a
## directory mentioned in the fpath parameter, and should be autoloaded
## (‘autoload -U compinit' is recommended), and then run simply as
## ‘compinit'.

## autoload compinit
### -U alias expansion is suppressed when the function is loaded
### -z mark the function to be autoloaded using the zsh style
autoload -Uz compinit

## initialize compinit
### -i ignores insecure files and directories
compinit -i
### for completion .*-files are matched without explicitly specifying the dot
_comp_options+=(globdots)
#CASE_SENSITIVE=true

## load zsh module completion listing extensions
zmodload zsh/complist

## zstyle
### command to define and lookup styles (pairs of names and values)
## completion pattern template
### :completion:<function>:<completer>:<command>:<argument>:<tag>
zstyle ':completion:*' menu select
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name

## completion style based of 'default' zls_colors
## see zsh manual: zshmodules(1) zsh/complist module
zstyle ':completion:*' list-colors $ZLS_COLORS

## ignore the /etc/hosts (which is mainly a blocklist) lookup for ssh
zstyle ':completion:*:ssh:*' hosts off
