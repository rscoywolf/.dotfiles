#!/bin/bash

for file in ~/.dotfiles/.config/*; do
    filename=$(basename "$file")
    if [ -e ~/.config/"$filename" ]; then
        mv ~/.config/"$filename" ~/.config/"${filename}_bkup"
    fi
    ln -s "$file" ~/.config/
done