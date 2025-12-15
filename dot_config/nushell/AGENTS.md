# Nushell Configuration

Documentation for AI agents working with this nushell config.

## Load Order

```
1. env.nu          → Runs FIRST (before autoload)
2. autoload/*.nu   → Sourced alphabetically
3. config.nu       → Runs LAST
```

## File Structure

| File | Purpose |
|------|---------|
| `env.nu` | Pre-autoload setup (zoxide generation) |
| `config.nu` | Shell settings (`$env.config.*`) |
| `autoload/env.nu` | Environment variables (`EDITOR`, etc.) |
| `autoload/shell.nu` | CLI aliases (`find=fd`, `grep=rg`, etc.) |
| `autoload/chezmoi.nu` | Dotfiles management aliases |
| `autoload/zoxide.nu` | **Generated** - do NOT edit manually |

## Key Behaviors

### Zoxide Self-Healing (env.nu)

`env.nu` auto-generates `zoxide.nu` if:
- The file is missing, OR
- Zoxide version has changed

This happens **before** autoload so `z` and `zi` commands are available immediately.

### Generated Files (in .chezmoiignore)

These files are generated at runtime and should NOT be committed:
- `autoload/zoxide.nu` 
- `autoload/.zoxide-version`
- `history.txt`

## Common Gotchas

1. **No multi-line `or` expressions** - Nushell parser doesn't like `foo or \n bar`. Use separate variables instead.

2. **Can't alias builtins** - `alias cd = z` won't work because `cd` is a builtin. Just use `z` directly.

3. **Autoload is alphabetical** - Files are sourced in alphabetical order within `autoload/`.

## Adding New Config

- **Environment variables** → `autoload/env.nu`
- **Shell aliases/functions** → `autoload/shell.nu`
- **New feature module** → Create `autoload/<feature>.nu`
- **Pre-autoload logic** → `env.nu` (sparingly)
- **Shell settings** → `config.nu`
