# Shell utilities

def reload [] { exec nu }

# Quick path to ~/.config
def cfg [subpath?: string] {
    let base = ($env.HOME | path join ".config")
    if ($subpath | is-empty) {
        $base
    } else {
        $base | path join $subpath
    }
}

