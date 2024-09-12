#! /usr/bin/env sh


function def-cursor ()
{
    ## define cursor styles
    local style

    case $1 in

        reset)
	    # to default
	    style=0
	    ;;

	block_blink)
	    # default
	    style=1
	    ;;

	block_steady)
	    style=2
	    ;;

	underline_blink)
	    style=3
	    ;;

	underline_steady)
	    style=4
	    ;;

	vertical-line_blink)
	    style=5
	    ;;

	vertical-line_steady)
	    style=6
	    ;;

	*)
	    style=0
	    ;;

    esac

    ### define cursor
    [ $style -ge 0 ] && echo -n "\e[${style} q"
}


function set-cursor ()
{
    ## set cursor styles
    case $KEYMAP in

        main | viins)
	    def-cursor vertical-line_blink
	    ;;

        vicmd)
	    def-cursor block_blink
	    ;;

        visual)
	    def-cursor block_steady
	    ;;

	*)
	    def-cursor underline_blink
	    ;;

    esac
}


function zle-keymap-select ()
{
    ## set_ps1
    set-cursor
    zle reset-prompt
}


function zle-line-init ()
{
    zle -K $DEFAULT_VI_MODE
    ## set_ps1
    set-cursor
    zle reset-prompt
}


function zle-line-finish ()
{
    ## set_ps1
    set-cursor
    zle reset-prompt
}

