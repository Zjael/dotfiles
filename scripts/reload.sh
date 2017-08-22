#!/bin/bash
pkill compton
compton &

killall dunst
dunst -conf ~/.config/dunst/dunstrc &

pkill polybar
polybar main &