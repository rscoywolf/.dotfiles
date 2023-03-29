#!/bin/bash

GH_USER="rscoywolf"
GH_BASEURL="https://github.com/${GH_USER}/"

REPO_FILE="repositories.txt"
if [[ ! -f "$REPO_FILE" ]]; then
  echo "Error: Repository file '$REPO_FILE' not found."
  exit 1
fi

while read -r repo; do
  if [[ -d "${HOME}/${repo}" ]]; then
    echo "Repository '${repo}' already cloned."
  else
    echo "Cloning repository '${repo}'..."
    git clone "${GH_BASEURL}${repo}.git" "${HOME}/${repo}"
  fi
done < "$REPO_FILE"

