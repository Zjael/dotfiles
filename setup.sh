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

    echo "#-- Installing Pacaur --#"
    install_pacaur

    echo "#-- Setting Up Firewall --#"
    set_firewall

    echo "#-- Setting Up SSH --#"
    set_ssh

    echo "#-- Setting Up Mirrorlist --#"
    set_mirrorlist
    
    echo "#-- Setting Up Hardware Clock --#"
    set_hwclock

    echo "#-- Installing Packages --#"
    install_packages

    echo "#-- Setting Up Shell --#"
    set_shell
}

set_locale() {
    echo "LANG=$LANG.UTF-8" >> /etc/locale.conf
    echo "LANG=$LANG.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
}

set_timezone() {
    ln -sT "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
}

set_keymap() {
	loadkeys $KEYMAP
    echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf
}

install_pacaur() {
    mkdir ~/tmp/pacaur
    cd ~/tmp/pacaur

    sudo pacman -Sy --needed base-devel --noconfirm
    sudo pacman -S binutils make gcc fakeroot --noconfirm --needed
    sudo pacman -S expac yajl git curl --noconfirm --needed

    # Install "cower" from AUR
    if [ ! -n "$(pacman -Qs cower)" ]; then
        gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
        curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
        makepkg -si PKGBUILD --noconfirm
    fi

    # Install "pacaur" from AUR
    if [ ! -n "$(pacman -Qs pacaur)" ]; then
        curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
        makepkg -si PKGBUILD --noconfirm
    fi

    cd ~
    sudo rm -r ~/tmp/pacaur
}

set_firewall() {
    sudo pacman -S ufw --noconfirm --needed

    iptables -F; iptables -X
    echo 'y' | ufw reset
    echo 'y' | ufw enable
    ufw default deny incoming
    ufw default deny forward

    # ufw logging on
    ufw allow 22,80,443/tcp
    # ufw allow $ssh_port/tcp
    # ufw allow from 192.168.10.0/24

    sudo systemctl enable --now ufw.service
}

set_ssh() {
	sudo pacman -S openssh --noconfirm --needed

	sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
	ufw allow from 192.168.10.0/24 to any port $ssh_port
	sudo systemctl --now enable sshd
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

    # General utilities/libraries
    packages+=' zsh tmux xclip curl httpie htop nethogs tree ranger autojump udevil thefuck micro rar unrar lm_sensors scrot neofetch'

    # Development
    packages+=' git gist'

    # Security
    packages+=' lynis'

    # Config
    packages+=' stow antigen-git'

    # Storage & Data
    packages+=' fzf rsync'

    # Desktop
    packages+=' waterfox-bin spotify blockify'

    # Enviroment
    packages+=' i3-gaps i3lock-fancy-git polybar'
    packages+=' termite rofi feh conky compton dunst xbacklight xorg xorg-xinit rxvt-unicode rxvt-unicode-terminfo'

    # Themes
    packages+=' gtk-arc-flatabulous-theme-git paper-icon-theme-git siji-git'

    # Fonts
    packages+=' powerline-fonts powerline nerd-fonts-complete'
    
    # For laptops
    packages+=' xf86-input-synaptics tlp thermald'


    pacaur -Sy --needed --noconfirm --noedit $packages
}

set_shell() {
    chsh -s `which zsh`
}

arch_setup