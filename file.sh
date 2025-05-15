#!/bin/bash

# Directory to start searching from (default is HOME)
SEARCH_DIR="${1:-$HOME}"

# Use find to get directories only and show via rofi
DIR=$(find "$SEARCH_DIR" -type d 2>/dev/null | rofi -dmenu -p "Open Dir in Neovim")

# If a directory was selected
if [[ -n "$DIR" ]]; then
    ghostty nvim "$DIR"
fi

