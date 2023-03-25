#!/bin/bash

# starts background slideshow of wallpapers
feh \
    --recursive \
    --randomize \
    --bg-fill \
    --quiet \
    --slideshow-delay 360 \
    ~/.dotfiles/.backgrounds

