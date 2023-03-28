#!/bin/bash

# set the path to your .git-credentials file
GIT_CREDENTIALS_FILE="/home/wolf/.git-credentials"

# read the first line of the .git-credentials file (assuming it contains your PAT)
CREDENTIALS=$(head -n 1 "$GIT_CREDENTIALS_FILE")

# extract the username and token from the credentials
USERNAME=$(echo "$CREDENTIALS" | sed 's|https://\([^:]*\):.*|\1|')
TOKEN=$(echo "$CREDENTIALS" | sed 's|https://[^:]*:\([^@]*\).*|\1|')

# output the username or token based on the input argument
if [ "$1" = "username" ]; then
    echo "$USERNAME"
elif [ "$1" = "password" ]; then
    echo "$TOKEN"
fi

