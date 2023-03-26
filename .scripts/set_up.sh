#!/bin/bash

# store current directory to variable
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# update and sync
sudo pacman -Syu

INSTALL_FLAGS="-S --needed --noconfirm --quiet"

# install the packages quietly
sudo pacman $INSTALL_FLAGS i3 
sudo pacman $INSTALL_FLAGS neovim 
sudo pacman $INSTALL_FLAGS feh 
sudo pacman $INSTALL_FLAGS fish 
sudo pacman $INSTALL_FLAGS redshift 
sudo pacman $INSTALL_FLAGS firefox 
sudo pacman $INSTALL_FLAGS signal-desktop 
sudo pacman $INSTALL_FLAGS discord 
sudo pacman $INSTALL_FLAGS neofetch 
sudo pacman $INSTALL_FLAGS fzf

# latex packages
read -p "Do you want to install latex packages? (y/n): " choice_latex

if [[ "$choice_latex" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed -noconfirm --quiet texlive-most
fi

# install drivers
read -p "Does this PC have an NVIDIA chip that is supported? (y/n): " supported_nvidia

if [[ "$supported_nvidia" =~ ^[Yy]$ ]]; then
    sudo mhwd -a pci nonfree 0300
else
    read -p "Try installing the auto-best drivers? (y/n): " auto_best_drivers
    if [[ "$auto_best_drivers" =~ ^[Yy]$ ]]; then
        sudo mhwd -a pci
    fi
fi

# geforce now (electron)
read -p "Install GeForce Now? (y/n): " choice_geforce_now
if [[ "$choice_geforce_now" =~ ^[Yy]$ ]]; then
    cd ~
    sudo pacman -S git base-devel
    git clone https://aur.archlinux.org/geforcenow-electron.git
    cd geforcenow-electron
    makepkg -si
fi

# install snap
cd ~/Downloads
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# install snap apps
sudo snap install --classic code
sudo snap install teams-for-linux

# back to scripts directory
cd $DIR

# run the script called link_configs.sh
echo "Setting up config files (old ones renamed to *_bkup)..."
chmod +x link_configs.sh
(./link_configs.sh)

# put scripts in bin
echo "Setting up scripts in /bin/..."
chmod +x link_bin.sh
(./link_bin.sh)


# git
echo "Configuring git..."
git config --global user.email "rscoywolf@gmail.com"
git config --global user.name "rscoywolf"
git config credential.helper store

cd ~
read -p "Clone schoolwork repo? (y/n): " clone_schoolwork
if [[ "$clone_schoolwork" =~ ^[Yy]$ ]]; then
    git clone https://github.com/rscoywolf/schoolwork.git
fi
