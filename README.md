# Dotfiles

## 🚀 Quick Start (Bootstrap)

sh -c "$(curl -fsLS https://raw.githubusercontent.com/AneeshBoreda/dotfiles/master/bootstrap.sh)"
```

### What this does:
1. Detects your **Arch-based** distro (Manjaro vs standard Arch).
2. Installs `chezmoi` and `git` using `pamac` or `pacman`.
3. Clones the repo from `https://github.com/AneeshBoreda/dotfiles`.
3. Installs **Nushell** (via pacman) if missing.
4. Installs all packages defined in `.chezmoidata/packages.toml` (Official & AUR).
5. Applies all dotfiles to your home directory.

**Note on Paths:** Chezmoi automatically adapts to your user home directory, so it works regardless of your username or specific home path (e.g. `/home/username/`).
