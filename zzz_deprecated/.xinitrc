#
##         _       _ _            
##   __  _(_)_ __ (_) |_ _ __ ___ 
##   \ \/ / | '_ \| | __| '__/ __|
##  _ >  <| | | | | | |_| | | (__ 
## (_)_/\_\_|_| |_|_|\__|_|  \___|
##  _ _|_ _ ._    _  _  
## (_\/|_(_)|_)\/(_|(/_ 
##   /      |  /  _|    
##
## .xinitrc
## xinitrc
## xorg initial configuration
## by cytopyge
##
#

#
## this file:
##  is being sourced by ~/.xinitrc
##  overrides default /etc/X11/xinit/xinitrc
#

# define monitors
## from xrandr
laptop_display=eDP1
external_monitor=DP1

# !! check dpi settings in .Xresources (Xft.dpi) !!

# display resolution configuration
## xps
#xrandr --output eDP1 --mode 3200x1800  
## vestigo 
# xrandr --output DVI-I-1 --mode 1920x1080 --rate 60

## toggle external monitor
if xrandr | grep "$external_monitor connected"; then
	xrandr --output eDP1 --primary --output DP1 --above eDP1 --mode 2560x1440
else
	xrandr --output eDP1
fi

## call .Xresources
xrdb -I$HOME ~/.dot/.Xresources
[[ -f ~/.dot/.Xresources ]] && xrdb -merge -I$HOME ~/.dot/.Xresources

## hide mouse when typing
unclutter &

## remap CAPS LOCK key to ESC key
xmodmap -e 'clear Lock' #switch CAPS LOCK key off
xmodmap -e 'keycode 0x42=Escape' #remap CAPS LOCK key to ESC key

## execute window manager
exec i3
