#!/bin/bash

for file in ~/.dotfiles/.scripts/.bin/*; do
    filename=$(basename "$file")
    target_file=/bin/"$filename"
    if [[ -e "$target_file" && ! -L "$target_file" ]]; then
        mv "$target_file" "${target_file}_bkup"
    elif [[ -L "$target_file" ]]; then
        rm "$target_file"
    fi
    ln -s "$file" "$target_file"
done
