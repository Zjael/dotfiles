install: install-pacaur install-packages enable-services link-config set-shell
configure: set-country mirrorlist firewall
laptop: laptop-services
help:
	@echo "  install			installing and setting up pacaur & packages"
	@echo "  configure			keymap, language, mirrorlist & firewall"
	@echo "  laptop				laptop specific packages & services"
	@echo "  =========== single commands ==========="
	@echo "  ssh				enabling & setup of SSH"
	@echo "  SSD				SSD improvements - swappiness & etc."


install-packages:
	sudo pacman -Syu --noconfirm
	sudo pacman -Sy yaourt
	pacaur -S --needed --noconfirm --noedit `cat packages.txt`

add-repositories:
	cat repositories.txt | sudo tee -a /etc/pacman.conf

enable-services:
	sudo systemctl enable lightdm NetworkManager

laptop-services:
	sensors-detect
	systemctl enable tlp tlp-sleep
	systemctl disable systemd-rfkill
	sudo tlp start

	systemctl enable --now thermald

firewall:
	pacaur -S --needed --noconfirm ufw
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

mirrorlist:
	pacaur -S --needed --noconfirm reflector
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
	reflector --country DK -p http --save /etc/pacman.d/mirrorlist

ssh:
	pacaur -S --needed --noconfirm openssh
	ssh_port="505050"

	echo "Please type your wanted SSH port or Press [ENTER] for default '505050'"
	read -p 'Port: ' ssh_port
	if [ -z "$ssh_port" ]; then
		ssh_port="505050"
		echo "Changing SSH Port to: $ssh_port"
	fi

	sed -i "s/#Port 22/Port $ssh_port/g" /etc/ssh/sshd_config
	grep "Port " /etc/ssh/sshd_config > gPort
	if [ ! "Port $ssh_port" == gPort ]; then
		echo "[FAILED] Changing SSH Port"
		echo "Press [ENTER] to manually edit the port '505050' prefered"
		read continue
		sudo nano /etc/ssh/sshd_config
	fi

	ufw allow from 192.168.10.0/24 to any port $ssh_port
	sudo systemctl --now enable sshd

link-config:
	stow --restow `ls -d */`

set-shell:
	chsh -s `which zsh`

set-country:
	lang=en_DK
	keymap=dk
	timezone="Europe/Copenhagen"

	loadkeys $keymap
	echo "KEYMAP=$keymap" >>/etc/vconsole.conf

	echo "LANG=$lang.UTF-8" >/etc/locale.conf
	sed -i "/#$lang/s/^#//" /etc/locale.gen
	locale-gen

	ln -sf /usr/share/zoneinfo/$timezone /etc/localtime

	# update hardware clock
	sudo pacman -S ntp --noconfirm --needed
	timedatectl set-ntp true
	hwclock --systohc --utc
	sudo systemctl enable --now ntpd

SSD: 
	echo "vm.swappiness=1" > /etc/sysctl.conf

install-pacaur:
	mkdir ~/tmp/pacaur
	cd ~/tmp/pacaur

	sudo pacman -Sy --needed base-devel --noconfirm
	sudo pacman -S binutils make gcc fakeroot --noconfirm --needed
	sudo pacman -S expac yajl git curl --noconfirm --needed

	if [ ! -n "$(pacman -Qs cower)" ]; then
		gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
		curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
		makepkg -si PKGBUILD --noconfirm
	fi
	if [ ! -n "$(pacman -Qs pacaur)" ]; then
		curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
		makepkg -si PKGBUILD --noconfirm
	fi

	cd ~
	sudo rm -r ~/tmp/pacaur