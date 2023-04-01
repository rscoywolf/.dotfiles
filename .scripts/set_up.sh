#!/bin/bash

# store current directory to variable
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# update and sync
sudo pacman -Syu


INSTALL_FLAGS="-S --needed --noconfirm --quiet"

# install the packages quietly
sudo pacman $INSTALL_FLAGS yay
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
sudo pacman $INSTALL_FLAGS xfce4-settings
sudo pacman $INSTALL_FLAGS unzip
sudo pacman $INSTALL_FLAGS polybar
sudo pacman $INSTALL_FLAGS nitrogen
sudo pacman $INSTALL_FLAGS picom

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
read -p "Install snap? (y/n): " choice_snap

if [[ "$choice_snap" =~ ^[Yy]$ ]]; then
    cd ~/Downloads
    git clone https://aur.archlinux.org/snapd.git
    cd snapd
    makepkg -si
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
    # install snap apps
    read -p "Install VS Code and Teams for Linux? (y/n): " choice_snap_apps
    if [[ "$choice_snap_apps" =~ ^[Yy]$ ]]; then
        sudo snap install --classic code
        sudo snap install teams-for-linux
    fi
fi



# back to scripts directory
cd $DIR

# run the script called link_configs.sh
echo "----------------------------------------------------"
echo "Setting up config files (old ones renamed to *_bkup)"
echo "----------------------------------------------------"
chmod +x .bin/link_configs.sh
(.bin/link_configs.sh)


# source .Xresources
xrdb -merge ~/.Xresources


# put scripts in bin
echo "---------------------------"
echo "Setting up scripts in /bin/"
echo "---------------------------"
chmod +x link_bin.sh
(.bin/link_bin.sh)


# git
echo "Configuring git..."
git config --global user.email "rscoywolf@gmail.com"
git config --global user.name "rscoywolf"
git config --global credential.helper store

cd ~
read -p "Clone repos? (y/n): " clone_repos
if [[ "$clone_repos" =~ ^[Yy]$ ]]; then
    chmod +x ./.bin/clone_repos.sh
    (./.bin/clone_repos.sh)
fi
