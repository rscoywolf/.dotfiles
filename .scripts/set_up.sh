#!/bin/bash

# store current directory to variable
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# install the packages
sudo pacman -S i3
sudo pacman -S neovim
sudo pacman -S feh
sudo pacman -S fish
sudo pacman -S redshift
sudo pacman -S firefox
sudo pacman -S signal-desktop
sudo pacman -S discord
sudo pacman -S neofetch
sudo pacman -S fzf
sudo pacman -S texlive-most
# nvidia drivers
sudo mhwd -a pci nonfree 0300

# geforce now
cd ~
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/geforcenow-electron.git
cd geforcenow-electron
makepkg -si

# install snap
cd ~/Downloads
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# install snap apps
sudo snap install --classic code

# back to scripts directory
cd $DIR

# run the script called link_configs.sh
chmod +x link_configs.sh
(./link_configs.sh)

# put scripts in bin
chmod +x link_bin.sh
(./link_bin.sh)


# git
git config --global user.email "rscoywolf@gmail.com"
git config --global user.name "rscoywolf"
git config credential.helper store

cd ~
git clone https://github.com/rscoywolf/schoolwork.git
