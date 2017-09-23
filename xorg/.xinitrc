#!/bin/sh
#          ██          ██   ██                  
#         ░░          ░░   ░██                  
#  ██   ██ ██ ███████  ██ ██████ ██████  █████  
# ░░██ ██ ░██░░██░░░██░██░░░██░ ░░██░░█ ██░░░██ 
#  ░░███  ░██ ░██  ░██░██  ░██   ░██ ░ ░██  ░░  
#   ██░██ ░██ ░██  ░██░██  ░██   ░██   ░██   ██ 
#  ██ ░░██░██ ███  ░██░██  ░░██ ░███   ░░█████  
# ░░   ░░ ░░ ░░░   ░░ ░░    ░░  ░░░     ░░░░░  

setxkbmap dk &
xrdb -merge ~/.Xresources &
xsetroot -cursor_name left_ptr &
dunst -conf ~/.config/dunst/dunstrc &
nitrogen --set-scaled ~/dotfiles/wallpapers/astronout.jpg &


export DPI=96
xrandr --dpi $DPI

SESSION=hlwm
case $1 in
	hlwm) exec herbstluftwm ;;
	2bwm) exec 2bwm ;;
	*) exec $SESSION ;;
esac