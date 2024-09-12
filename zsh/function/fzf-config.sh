#! /usr/bin/env sh


fzf-config ()
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
