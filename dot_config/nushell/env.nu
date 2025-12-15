# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# Zoxide: self-healing setup (regenerates if missing or version changed)
# Must be in main env.nu (not autoload) so zoxide.nu exists BEFORE autoload sources it
if (which zoxide | is-not-empty) {
    let autoload_dir = ($env.HOME | path join ".config/nushell/autoload")
    let zoxide_file = ($autoload_dir | path join "zoxide.nu")
    let version_file = ($autoload_dir | path join ".zoxide-version")
    let current_version = (zoxide --version)
    
    let file_missing = not ($zoxide_file | path exists)
    let version_missing = not ($version_file | path exists)
    let version_changed = if $version_missing { false } else { (open $version_file | str trim) != $current_version }
    
    if ($file_missing or $version_missing or $version_changed) {
        mkdir $autoload_dir
        zoxide init nushell | save -f $zoxide_file
        $current_version | save -f $version_file
        print $"(ansi green)✓ Generated zoxide.nu for ($current_version)(ansi reset)"
    }
}