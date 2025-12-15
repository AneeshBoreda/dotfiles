# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

def reload [] { exec nu }

alias dot = chezmoi               # Main chezmoi command
alias dotd = chezmoi diff          # Preview changes before applying
alias dota = chezmoi apply -v      # Apply source → home
alias dotr = chezmoi re-add        # Sync home → source (re-add changed files)
alias dotu = chezmoi update -v     # Pull from git + apply

# Git wrapper using chezmoi's source path
def dg [...args: string] {
    git -C (chezmoi source-path) ...$args
}

# Quick commit and push
def dotsync [message: string = "Update dotfiles"] {
    let src = (chezmoi source-path)
    git -C $src add -A
    git -C $src commit -m $message
    git -C $src push
}
