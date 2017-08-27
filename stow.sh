#!/bin/bash -e

SILENT=${SILENT-true}

DIRNAME=$(dirname $0)
cd $DIRNAME

MODULES=( "compton" "dunst" "i3" "polybar" "rofi" "Xresources" "zsh" "xorg")

ARG="-t /home/$USER"

if [ "$1" == "un" ]; then
    ARG="-D -t /home/$USER"
fi

for module in "${MODULES[@]}"; do
    [ "$SILENT" == "false" ] && echo "stow $ARG $module"
    stow $ARG $module
done

sudo chmod -R 755 /home/$USER/.config
sudo chmod -R 755 /home/$USER/dotfiles/scripts