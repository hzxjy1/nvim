#!/bin/bash

if ! command -v nvim &>/dev/null; then
    echo "Error: nvim not found. Please install nvim first."
    exit 1
fi

NVIM_PATH=$(command -v nvim)
VI_PATH=$(which vi)

if [ -z "$VI_PATH" ]; then
    echo "Error: vi command not found."
    exit 1
fi

if [ ! -L "$VI_PATH" ]; then
    echo "Error: $VI_PATH is not a symlink. Aborting for safety."
    exit 1
fi

BACKUP_PATH="${VI_PATH}.bak"
echo "Backing up original link: $VI_PATH -> $BACKUP_PATH"
sudo mv "$VI_PATH" "$BACKUP_PATH"

echo "Creating new link: $VI_PATH -> $NVIM_PATH"
sudo ln -s "$NVIM_PATH" "$VI_PATH"
