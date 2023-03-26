#!/bin/bash

for file in ~/.dotfiles/.config/*; do
    filename=$(basename "$file")
    target_file=~/.config/"$filename"
    if [[ -e "$target_file" && ! -L "$target_file" ]]; then
        mv ">$target_file" "${target_file}_bkup"
    elif [[ -L "$target_file" ]]; then
        rm "$target_file"
    fi
    echo "linking $target_file..."
    ln -s "$file" "$target_file"
done

for file in ~/.dotfiles/.homeconfig/; do
    filename=$(basename "$file")
    target_file=~/"$filename"
    if [[ -e "$target_file" && ! -L "$target_file" ]]; then
        mv ">$target_file" "${target_file}_bkup"
    elif [[ -L "$target_file" ]]; then
        rm "$target_file"
    fi
    echo "linking $target_file..."
    ln -s "$file" "$target_file"
done
