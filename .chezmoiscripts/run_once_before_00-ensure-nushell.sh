#!/bin/bash

# Ensure Nushell is installed before running other scripts
# This runs before any other run_onchange script because of the 'before_' prefix

set -eu

if ! command -v nu >/dev/null 2>&1; then
    echo "Nushell not found. Installing..."
    
    if command -v pamac >/dev/null 2>&1; then
        echo "Detected Manjaro (pamac). Installing nushell..."
        pamac install --no-confirm nushell
    elif command -v pacman >/dev/null 2>&1; then
        echo "Detected Arch (pacman). Installing nushell..."
        sudo pacman -S --needed --noconfirm nushell
    else
        echo "Error: Nushell not found and could not detect pacman."
        echo "Please install 'nushell' manually to proceed."
        exit 1
    fi
else
    echo "Nushell is already installed."
fi
