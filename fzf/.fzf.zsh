# setup fzf
# ---------
if [[ ! "$PATH" == *#HOME/.config/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.config/fzf/.fzf/bin"
fi

# auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.config/fzf/.fzf/shell/completion.zsh" 2> /dev/null

# key bindings
# ------------
source "$XDG_CONFIG_HOME/fzf/.fzf/shell/key-bindings.zsh"
