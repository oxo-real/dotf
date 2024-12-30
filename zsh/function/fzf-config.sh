#! /usr/bin/env sh

# --------------------------------------------------------------------
# fzf-config.sh


function fzf-config ()
{
    ## https://github.com/junegunn/fzf#installation
    ## WARNING path is modified here
    [[ -f $fzf_zsh ]] && source $fzf_zsh

    # $fzf_zsh
    # sources:
    # $XDG_CONFIG_HOME/fzf/.fzf/shell/key-bindings.zsh
    # which defines keybindings:
    # CTRL-T - Paste the selected file path(s) into the command line
    # ALT-C - cd into the selected directory
    # CTRL-R - Paste the selected command from history into the command line

    # $XDG_CONFIG_HOME/zsh/.zshenv
    # defines:
    # FZF_DEFAULT_OPS environment variable defines fzf default options

    ## fzf-tab
    ## https://github.com/Aloxaf/fzf-tab
    ## WARNING fpath is modified here
    [[ -f $fzf_tab ]] && source $fzf_tab

    ## fzf-tab-completions
    ## https://github.com/lincheney/fzf-tab-completion
    #source $XDG_CONFIG_HOME/fzf-tab-completion/zsh/fzf-zsh-completion.sh
}

fzf-config


#  ## [Ctrl-r for shell history but also bulk select and remove from history · junegunn/fzf · Discussion #3629 · GitHub](https://github.com/junegunn/fzf/discussions/3629)
#  function modified-fzf-history-widget ()
#  {
#      local selected
#      setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases no_bash_rematch 2> /dev/null
#
#      ## appends the current shell history buffer to the HISTFILE
#      builtin fc -AI $HISTFILE
#
#      ## pushes entries from the $HISTFILE onto a stack and uses this history
#      builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST
#
#      selected="$(builtin fc -rl 1 |
#      awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
#      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} --multi" $(__fzfcmd))"
#
#      local ret=$?
#      if [[ -n $selected ]]; then
#
#  	if [[ "$selected" =~ ^[[:blank:]]*[[:digit:]]+ ]]; then
#
#  	    builtin fc -pa "$HISTFILE"
#  	    zle vi-fetch-history -n "$MATCH"
#
#  	else # selected is a custom query, not from history
#
#  	    LBUFFER="$selected"
#
#  	fi
#
#      fi
#
#      ## read the history from the history file into the history list
#      builtin fc -R $HISTFILE
#      zle reset-prompt
#      return $ret
#  }
#
#  zle -N modified-fzf-history-widget
#
#
#  export FZF_CTRL_R_OPTS="$(
#  	cat <<'FZF_FTW'
#  --bind "ctrl-d:execute-silent(zsh -ic 'builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST; for i in {+1}; do ignore+=( \"${(b)history[$i]}\" );done;
#  	HISTORY_IGNORE=\"(${(j:|:)ignore})\";builtin fc -W $HISTFILE')+reload:builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST; builtin fc -rl 1 |
#  	awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, \"\", cmd); if (!seen[cmd]++) print $0 }'"
#  --bind 'enter:accept-or-print-query'
#  FZF_FTW
#  )"
#  #--prompt ' Global History > '
#  #--header 'select [RET] remove [C-d]'
