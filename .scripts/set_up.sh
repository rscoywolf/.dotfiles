#!/bin/bash

# install the packages
sudo pacman -S i3 nvim feh fish redshift firefox signal-desktop discord

# run the script called link_configs.sh
chmod +x link_configs.sh
(./link_configs.sh)

# put scripts in bin
chmod +x link_bin.sh
(./link_bin.sh)
