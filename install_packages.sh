#!/bin/bash

local packages=''
# System utilities
packages+=' networkmanager lm_sensors thermald redshift curl wget httpie htop nethogs udevil rar unrar scrot neofetch'

# Terminal
packages+=' zplug tmux tree ranger autojump thefuck micro'
packages+=' rtv'

# Development
packages+=' git gist tig'
packages+=' python python-pip python-setuptools python-virtualenv python2 python2-pip python2-setuptools python2-virtualenv python-virtualenvwrapper'
packages+=' nodejs npm'

# Security
packages+=' lynis firejail'

# Storage & Data
packages+=' fzf rsync'

# Xorg
packages+=' xorg xorg-xinit xbacklight'

# Desktop
packages+=' waterfox-bin spotify blockify emacs xclip cups'

# For fun
packages+=' cowsay lolcat fortune-mod'

# Enviroment
packages+=' i3-gaps i3lock-fancy-git polybar'
packages+=' stow termite rofi feh conky compton dunst rxvt-unicode rxvt-unicode-terminfo'

# Themes
packages+=' gtk-arc-flatabulous-theme-git paper-icon-theme-git siji-git'

# Fonts
packages+=' powerline-fonts powerline nerd-fonts-complete'

#pacaur -S --needed --noconfirm --noedit $packages
for pkg in $packages; do
    pacaur -S --needed --noconfirm --noedit $pkg
done