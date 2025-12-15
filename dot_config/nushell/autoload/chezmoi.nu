# Chezmoi dotfiles management

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
