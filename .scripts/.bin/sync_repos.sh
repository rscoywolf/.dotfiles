#!/bin/bash

export GIT_ASKPASS="~/.dotfiles/.scripts/git-credential-helper.sh"

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
