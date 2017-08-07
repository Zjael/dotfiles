#!/bin/bash

LANG="en_DK"
TIMEZONE="Europe/Copenhagen"
KEYMAP="dk"

SSH_PORT="505050"
MIRROR_LOCATION="DK"

arch_setup() {
    echo "#-- Setting Locale --#"
    set_locale

    echo "#-- Setting Timezone --#"
    set_timezone

    echo "#-- Setting Keymap --#"
    set_keymap

    echo "#-- Setting Up Firewall --#"
    set_firewall

    echo "#-- Setting Up SSH --#"
    set_ssh

    echo "#-- Setting Up Mirrorlist --#"
    set_mirrorlist
    
    echo "#-- Setting Up Hardware Clock --#"
    set_hwclock

    echo "#-- Installing Packages --#"
    #install_packages

    echo "#-- Setting Up Shell --#"
    set_shell
}

set_locale() {
    echo "LANG=$LANG.UTF-8" >> /etc/locale.conf
    echo "LANGUAGE=$LANG" >> /etc/locale.conf
    echo "$LANG.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
}

set_timezone() {
    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
}

set_keymap() {
	loadkeys $KEYMAP
    echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf
    setxkbmap $KEYMAP
}

set_firewall() {
    sudo pacman -S ufw --noconfirm --needed
    iptables -F; iptables -X
    echo 'y' | ufw reset
    echo 'y' | ufw enable
    ufw default deny incoming
    ufw default deny forward
    #ufw logging on
    ufw allow 22,80,443/tcp
    sudo systemctl enable --now ufw
}

set_ssh() {
	sudo pacman -S openssh --noconfirm --needed
    echo -e "\r\nPort $SSH_PORT" >> /etc/ssh/sshd_config
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
	ufw allow from 192.168.10.0/24 to any port $SSH_PORT
	sudo systemctl enable --now sshd
}

set_hwclock() {
    sudo pacman -S ntp --noconfirm --needed
    timedatectl set-ntp true
    hwclock --systohc --utc
    sudo systemctl enable --now ntpd
}

set_mirrorlist() {
    sudo pacman -S reflector --noconfirm --needed
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    reflector --country $MIRROR_LOCATION -p http --save /etc/pacman.d/mirrorlist
}

install_packages() {
    local packages=''
    # System
    packages+=' networkmanager'

    # Terminal
    packages+=' tmux tree ranger autojump thefuck micro'

    # General utilities/libraries
    packages+=' xclip curl httpie htop nethogs udevil rar unrar lm_sensors scrot neofetch'

    # Development
    packages+=' git gist'

    # Security
    packages+=' lynis'

    # Config
    packages+=' stow antigen-git'

    # Storage & Data
    packages+=' fzf rsync'

    # Xorg
    packages+=' xorg xorg-xinit xbacklight'

    # Desktop
    packages+=' waterfox-bin spotify blockify emacs'

    # Enviroment
    packages+=' i3-gaps i3lock-fancy-git polybar'
    packages+=' termite rofi feh conky compton dunst  rxvt-unicode rxvt-unicode-terminfo'

    # Themes
    packages+=' gtk-arc-flatabulous-theme-git paper-icon-theme-git siji-git'

    # Fonts
    packages+=' powerline-fonts powerline nerd-fonts-complete'
    
    # For laptops
    packages+=' xf86-input-synaptics tlp thermald'


    pacaur -S --needed --noconfirm --noedit $packages
}

set_shell() {
    sudo pacman -S zsh --noconfirm --needed
    chsh -s $(which zsh)
}

arch_setup