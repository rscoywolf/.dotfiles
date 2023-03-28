#!/bin/bash

export HOME="/home/wolf" 


cd ~/.dotfiles/
git pull
git add .
git commit -m "auto commit"
git push

if [ -d ~/schoolwork ]; then
    cd ~/schoolwork
    git pull
    git add .
    git commit -m "auto commit"
    git push
fi
