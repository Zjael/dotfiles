#!/bin/bash
pkill compton
compton &

killall dunst
dunst -conf ~/.config/dunst/dunstrc &

xrdb -load ~/.Xresources

pkill polybar
polybar main &