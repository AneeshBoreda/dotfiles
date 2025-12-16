# Shell utilities

def reload [] { exec nu }

# Modern CLI replacements (install via: cargo install fd-find ripgrep bat zoxide)
alias grep = rg
alias cat = bat --paging=never

# Quick path to ~/.config
def cfg [subpath?: string] {
    let base = ($env.HOME | path join ".config")
    if ($subpath | is-empty) {
        $base
    } else {
        $base | path join $subpath
    }
}

