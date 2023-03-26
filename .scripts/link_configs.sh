#!/bin/bash

shopt -s dotglob
for file in ~/.dotfiles/.config/*; do
    filename=$(basename "$file")
    target_file=~/.config/"$filename"
    if [[ -e "$target_file" && ! -L "$target_file" ]]; then
        mv "$target_file" "${target_file}_bkup"
    elif [[ -L "$target_file" ]]; then
        rm "$target_file"
    fi
    echo "linking $target_file..."
    ln -s "$file" "$target_file"

    if [[ "$filename" == ".i3" ]]; then
        home_target_file=~/"$filename"
        if [[ -e "$home_target_file" && ! -L "$home_target_file" ]]; then
            mv "$home_target_file" "${home_target_file}_bkup"
        elif [[ -L "$home_target_file" ]]; then
            rm "$home_target_file"
        fi
        echo "linking $home_target_file..."
        ln -s "$file" "$home_target_file"
    fi
done

for file in ~/.dotfiles/.homeconfig/*; do
    filename=$(basename "$file")
    target_file=~/"$filename"
    if [[ -e "$target_file" && ! -L "$target_file" ]]; then
        mv "$target_file" "${target_file}_bkup"
    elif [[ -L "$target_file" ]]; then
        rm "$target_file"
    fi
    echo "linking $target_file..."
    ln -s "$file" "$target_file"
done
shopt -u dotglob
