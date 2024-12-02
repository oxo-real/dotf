#! /usr/bin/env sh

# --------------------------------------------------------------------
# decorations.sh


function decorations ()
{
    ## define text style with select & paste
    ## with alacritty this is overridden by [colors.selection]
     zle_highlight=(\
      isearch:fg=#bbbbbb,bg=#000000 \
          region:fg=#000000,bg=#555555 \
          special:fg=#bbbbbb,bg=#000000 \
          suffix:fg=#bbbbbb,bg=#000000 \
          paste:fg=#bbbbbb,bg=#000000
     )


    ## syntax highlighting
    #source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [[ -f $zsh_syntax_hl ]] && source $zsh_syntax_hl
}

decorations


function base16-config ()
{
    ## base16-shell colorscheme
    ## https://github.com/chriskempson/base16-shell

    ## source profile_helper
    BASE16_SHELL="$XDG_CONFIG_HOME/base16-shell/"
    [ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	source "$BASE16_SHELL/profile_helper.sh"
}

base16-config

    ## set base16_shell colorscheme
    base16_irblack
