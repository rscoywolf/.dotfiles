#!/bin/bash

chmod +x "${HOME}/.dotfiles/.scripts/git-credential-helper.sh"
export GIT_ASKPASS="${HOME}/.dotfiles/.scripts/git-credential-helper.sh"

REPO_FILE="${HOME}/.dotfiles/.scripts/repositories.txt"

if [[ ! -f "$REPO_FILE" ]]; then
    echo "Error: Repository file '$REPO_FILE' not found."
    exit 1
fi

while read -r repo; do
    if [[ -d "${HOME}/${repo}" ]]; then
        echo "-------------------------"
        echo "${repo}"
        echo "-------------------------"
        cd "${HOME}/${repo}"
        git pull

        # sync submodules
        git submodule update --init --recursive
        git submodule foreach --recursive 'git checkout main; git pull'
        git submodule foreach --recursive 'git add .; git commit -m "auto commit"; git push'

        git add .
        git commit -m "auto commit"
        git push
    fi
done < "$REPO_FILE"
