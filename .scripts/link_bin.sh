#!/bin/bash

for file in ~/.dotfiles/.scripts/.bin/*; do
    filename=$(basename "$file")
    target_file=/bin/"$filename"
    if [[ -e "$target_file" && ! -L "$target_file" ]]; then
        sudo mv "$target_file" "${target_file}_bkup"
    elif [[ -L "$target_file" ]]; then
        sudo rm "$target_file"
    fi
    chmod +x "$file"
    echo "linking $target_file..."
    sudo ln -s "$file" "$target_file"
done
