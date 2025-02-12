# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cytopyge/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/cytopyge/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/cytopyge/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/cytopyge/.fzf/shell/key-bindings.bash"
