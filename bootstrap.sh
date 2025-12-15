#!/bin/sh

# Bootstrap script for dotfiles (Arch/Manjaro only)
# Installs git and chezmoi using the system package manager, then initializes chezmoi.

set -e

echo ">> Detecting Arch-based distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
else
    OS=$(uname -s)
fi

echo ">> Detected OS: $OS"

if command -v pamac >/dev/null 2>&1; then
    # Manjaro - prefer pamac (handles locks and sudo gracefully)
    echo ">> Found pamac (Manjaro). Installing git and chezmoi..."
    pamac install --no-confirm git chezmoi

elif command -v pacman >/dev/null 2>&1; then
    # Standard Arch
    echo ">> Found pacman (Arch). Installing git and chezmoi..."
    sudo pacman -S --needed --noconfirm git chezmoi

else
    echo "Error: This bootstrap script only supports Arch-based distributions (pacman/pamac)."
    echo "Please install 'git' and 'chezmoi' manually."
    exit 1
fi

echo ">> Initializing dotfiles..."
chezmoi init --apply https://github.com/AneeshBoreda/dotfiles
