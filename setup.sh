#!/bin/bash
LANG="en_DK"
TIMEZONE="Europe/Copenhagen"
KEYMAP="dk"
SSH_PORT="505050"
MIRROR_LOCATION="DK"

arch_setup() {
    if ! [ $(id -u) = 0 ]; then
        echo "ERROR: Script requires to be run as sudo or root."
        exit 1
    fi
    sudo pacman -Syu

    # TODO: Try make the functions below run as sudo separtately... sudo set_locale
    # Comment or Uncomment each of these functions to your liking
    echo "#-- Setting Locale --#"
    set_locale

    echo "#-- Setting Timezone --#"
    set_timezone

    echo "#-- Setting Up Hardware Clock --#"
    set_hwclock

    echo "#-- Setting Keymap --#"
    set_keymap

    echo "#-- Setting Up Firewall --#"
    set_firewall

    echo "#-- Setting Up SSH --#"
    set_ssh

    echo "#-- Setting Up Mirrorlist --#"
    set_mirrorlist

    echo "#-- Setting Up Shell --#"
    setup_shell

    echo "#-- Setting Up Laptop --#"
    #setup_laptop   # Setups TLP, Thermald & Microcode

    echo "#-- Setting Up Fstrim --#"
    #setup_fstrim   # Weekly SSD maintenance, make sure your SSD supports TRIM if unsure run 'lsblk -D'

    echo "#-- Installing Pacaur --#"
    install_pacaur

    echo "#-- Installing Packages --#"
    install_packages

    echo "#-- Setting Up Services --#"
    #setup_services

    echo "#-- Installing Python Packages --#"
    python_packages
}

set_locale() {
    echo "LANG=$LANG.UTF-8" > /etc/locale.conf
    echo "$LANG.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
}

set_timezone() {
    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
}

set_hwclock() {
    sudo pacman -S ntp --noconfirm --needed
    timedatectl set-ntp true
    hwclock --systohc --utc
    systemctl enable --now ntpd.service
}

set_keymap() {
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
    loadkeys $KEYMAP
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
    systemctl enable --now ufw.service
}

set_ssh() {
	sudo pacman -S openssh --noconfirm --needed
    echo -e "\r\nPort $SSH_PORT" >> /etc/ssh/sshd_config
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
	ufw allow from 192.168.10.0/24 to any port $SSH_PORT
	sudo systemctl enable --now sshd.service
}

set_mirrorlist() {
    sudo pacman -S reflector --noconfirm --needed
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    reflector --country $MIRROR_LOCATION -p http --save /etc/pacman.d/mirrorlist
}

setup_shell() {
    sudo pacman -S zsh --noconfirm --needed
    chsh -s $(which zsh)
}

setup_laptop () {
    sudo pacman -S xf86-input-synaptics tlp --noconfirm --needed
	systemctl enable --now tlp
	systemctl enable --now tlp-sleep
	systemctl mask --now systemd-rfkill.service systemd-rfkill.socket

    sudo pacman -S intel-ucode --noconfirm --needed
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

setup_fstrim() {
    pacman -S util-linux --noconfirm --needed
    systemctl enable --now fstrim fstrim.timer
}

install_pacaur() {
    sudo pacman -Syu

    sudo -u $SUDO_USER mkdir -p /tmp/pacaur_install
    cd /tmp/pacaur_install

    sudo pacman -S binutils make gcc fakeroot pkg-config --noconfirm --needed
    sudo pacman -S expac yajl git --noconfirm --needed

    # Install "cower" from AUR
    if [ ! -n "$(pacman -Qs cower)" ]; then
        curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
        sudo -u $SUDO_USER makepkg PKGBUILD --skippgpcheck --install --needed --noconfirm
    fi

    # Install "pacaur" from AUR
    if [ ! -n "$(pacman -Qs pacaur)" ]; then
        curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
        sudo -u $SUDO_USER makepkg PKGBUILD --install --needed --noconfirm
    fi

    cd ~
    rm -r /tmp/pacaur_install
}

install_packages() {
    local packages=''
    # System utilities
    packages+=' networkmanager lm_sensors thermald redshift curl wget httpie htop nethogs udevil rar unrar scrot neofetch'

    # Terminal
    packages+=' zplug tmux tree ranger autojump thefuck micro bash-snippets'
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

    for pkg in $packages; do
        sudo -u $SUDO_USER pacaur -S --needed --noconfirm --noedit $pkg
    done
}

setup_services() {
    sensors-detect
    systemctl enable --now thermald.service
    systemctl enable redshift.service
    systemctl enable --now org.cups.cupsd.service
}

python_packages() {
    pip install howdoi
    pip install tldr
    pip install jrnl
    pip3 install buku
}

arch_setup