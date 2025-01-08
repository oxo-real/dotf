#! /usr/bin/env sh

# --------------------------------------------------------------------
# keys.sh


# fix the workings of important keys

## get terminal escape sequence (SIGTERM) string via `cat` and
## pressing the targeted key there

### -M selects keymap
## backspace key in vicmd
bindkey -M vicmd '^?' backward-delete-char
## delete key in vicmd
bindkey -M vicmd '^[[3~' delete-char
## delete key in viins
bindkey -M viins '^[[3~' delete-char

## select viins keymap and bind it to main
bindkey -v

## add backspace (key sequence '^?') to main keymap
bindkey -v '^?' backward-delete-char

## inline history search
## NOTICE works also from vicmd with j and k (recommended)
### up arrow
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
### down arrow
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

## fOrm-feed (default C-l)
bindkey '^o' clear-screen               ## C-o


# for info on zsh keybindings:
# showkey --scancodes
# bindkey -l (zsh keymaps)
# bindkey -M <keymap>

# zsh -f /usr/share/zsh/functions/Misc/zkbd
# find keycode in zsh terminal with cat
# bindkey  now to clipboard             ## C-`

# spawn terminal into cwd
## M-S-Return
## --> see sway config


bindkey '^@' insert-date-time           ## C-2
bindkey '^E' insert-epoch               ## C-e
bindkey '^A' git-add-commit             ## C-a
bindkey '^h' cd-nav-dirs                ## C-h
bindkey '^j' cd-child                   ## C-j
bindkey '^k' cd-up                      ## C-k
bindkey '^l' cd-yazi                    ## C-l
bindkey '^f' insert-item-inline         ## C-f
bindkey '^Z' foreground                 ## C-z


bindkey -M vicmd 's' toggle-sudo        ## [vicmd] s
bindkey -M vicmd 'q' toggle-sh-x        ## [vicmd] q

: '
# additional notes on keybindings (oxo spicules)
bindkey -M vicmd 'cc'  ## change current line (clear > viins)
bindkey escape sequence: C-v $key (C-v ESC -> ^[)
# '
