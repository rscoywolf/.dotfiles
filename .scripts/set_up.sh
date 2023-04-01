#!/bin/bash

function install_packages() {
	# store current directory to variable
	DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

	# update and sync
	sudo pacman -Syu

	INSTALL_FLAGS="-S --needed --noconfirm --quiet"

	# install the packages quietly

	sudo pacman $INSTALL_FLAGS yay
	sudo pacman $INSTALL_FLAGS i3
	sudo pacman $INSTALL_FLAGS neovim
	sudo pacman $INSTALL_FLAGS feh
	sudo pacman $INSTALL_FLAGS alacritty
	sudo pacman $INSTALL_FLAGS fish
	chsh -s $(which fish)
	sudo pacman $INSTALL_FLAGS redshift
	sudo pacman $INSTALL_FLAGS firefox
	sudo pacman $INSTALL_FLAGS signal-desktop
	sudo pacman $INSTALL_FLAGS discord
	sudo pacman $INSTALL_FLAGS neofetch
	sudo pacman $INSTALL_FLAGS fzf
	sudo pacman $INSTALL_FLAGS xfce4-settings
	sudo pacman $INSTALL_FLAGS unzip
	sudo pacman $INSTALL_FLAGS polybar
	sudo pacman $INSTALL_FLAGS nitrogen
	sudo pacman $INSTALL_FLAGS picom
	sudo pacman $INSTALL_FLAGS pacmanfm
	sudo pacman $INSTALL_FLAGS fisher
	sudo pacman $INSTALL_FLAGS nodejs
	sudo pacman $INSTALL_FLAGS npm
	sudo pacman $INSTALL_FLAGS lazygit
	sudo pacman $INSTALL_FLAGS zathura-pdf-poppler
	yay -Syu
	yay $INSTALL_FLAGS zathura
}

function install_latex_packages() {
	read -p "Do you want to install latex packages? [y/N]: " choice_latex

	if [[ "$choice_latex" =~ ^[Yy]$ ]]; then
		sudo pacman -S --needed -noconfirm --quiet texlive-most
	fi
}

function install_nvidia_drivers() {
	read -p "Does this PC have an NVIDIA chip that is supported? [y/N]: " supported_nvidia

	if [[ "$supported_nvidia" =~ ^[Yy]$ ]]; then
		sudo mhwd -a pci nonfree 0300
	else
		read -p "Try installing the auto-best drivers? [y/N]: " auto_best_drivers
		if [[ "$auto_best_drivers" =~ ^[Yy]$ ]]; then
			sudo mhwd -a pci
		fi
	fi
}

function install_geforce_now() {
	read -p "Install GeForce Now? [y/N]: " choice_geforce_now
	if [[ "$choice_geforce_now" =~ ^[Yy]$ ]]; then
		cd ~
		sudo pacman -S git base-devel
		git clone https://aur.archlinux.org/geforcenow-electron.git
		cd geforcenow-electron
		makepkg -si
	fi
}

function install_snap() {
	read -p "Install snap? [y/N]: " choice_snap

	if [[ "$choice_snap" =~ ^[Yy]$ ]]; then
		cd ~/Downloads
		git clone https://aur.archlinux.org/snapd.git
		cd snapd
		makepkg -si
		sudo systemctl enable --now snapd.socket
		sudo ln -s /var/lib/snapd/snap /snap
		# install snap apps
		read -p "Install VS Code and Teams for Linux? [y/N]: " choice_snap_apps
		if [[ "$choice_snap_apps" =~ ^[Yy]$ ]]; then
			sudo snap install --classic code
			sudo snap install teams-for-linux
		fi
	fi
}

function setup_configs() {
	cd $DIR

	# run the script called link_configs.sh
	echo "----------------------------------------------------"
	echo "Setting up config files (old ones renamed to *_bkup)"
	echo "----------------------------------------------------"
	chmod +x .bin/link_configs.sh
	(.bin/link_configs.sh)

	# source .Xresources
	xrdb -merge ~/.Xresources
}

function setup_bin_scripts() {
	# put scripts in bin
	echo "---------------------------"
	echo "Setting up scripts in /bin/"
	echo "---------------------------"
	chmod +x link_bin.sh
	(.bin/link_bin.sh)
}

function setup_git() {
	echo "Configuring git..."
	git config --global user.email "rscoywolf@gmail.com"
	git config --global user.name "rscoywolf"
	git config --global credential.helper store
}

function clone_repos() {
	cd ~
	read -p "Clone repos? [y/N]: " clone_repos
	if [[ "$clone_repos" =~ ^[Yy]$ ]]; then
		chmod +x ./.bin/clone_repos.sh
		(./.bin/clone_repos.sh)
	fi
}

function setup_network_manager() {
	read -p "Install and configure networkmanager? [y/N]: " choice_netmang
	if [[ "$choice_netmang" =~ ^[Yy]$ ]]; then
		sudo pacman -S --needed --noconfirm --quiet networkmanager
		sudo systemctl enable --now NetworkManager
	fi
}

function create_non_root_user() {
	read -p "Create a non-root user? [y/N]: " choice_create_user
	if [[ "$choice_create_user" =~ ^[Yy]$ ]]; then
		read -p "Enter the username for the non-root user: " username
		sudo useradd -m -G wheel,audio,video,storage,optical -s /bin/bash $username
		sudo passwd $username
		sudo sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
	fi
}

function setup_display_manager() {
	read -p "Setup display manager? [y/N]: " choice_setup_display
	if [[ "$choice_setup_display" =~ ^[Yy]$ ]]; then
		sudo pacman -S --needed --noconfirm --quiet lightdm lightdm-gtk-greeter
		sudo systemctl enable --now lightdm
	fi

}

function install_dejavu_font() {
	cd $HOME/.dotfiles/.fonts/dejavu_sans_mono/
	mkdir -p ~/.local/share/fonts
	cp *.ttf ~/.local/share/fonts
	fc-cache -fv
}

install_packages
setup_network_manager
create_non_root_user
setup_display_manager
install_latex_packages
install_nvidia_drivers
install_geforce_now
install_snap
setup_configs
setup_bin_scripts
setup_git
install_dejavu_font
clone_repos
