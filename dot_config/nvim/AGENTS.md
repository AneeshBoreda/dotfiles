# Neovim Configuration Reference

This configuration is built to be **bleeding-edge**, **modular**, and **fast**. It uses `lazy.nvim` for package management and lazy-loading.

## Philosophy
- **Bleeding Edge**: Uses modern replacements (`blink.cmp` > `nvim-cmp`, `snacks.nvim` > `dashboard/indent-blankline`).
- **Modular**: Configuration is split by concern. Plugins are defined in `lua/plugins/*.lua` and return tables of specs.
- **Manual LSP**: No `mason-lspconfig` automagic. Servers are defined explicitly in `lua/plugins/lsp/`.

## Directory Structure
```
~/.config/nvim/
├── init.lua                # Entry point. Bootstraps lazy.nvim.
├── lua/
│   ├── config/             # Core Neovim Settings
│   │   ├── autocmds.lua    # Auto-commands
│   │   ├── keymaps.lua     # Global keymaps (leader is <Space>)
│   │   ├── lazy.lua        # Lazy.nvim setup
│   │   └── options.lua     # vim.opt settings
│   └── plugins/            # Plugins (specs per file)
│       ├── coding.lua      # Coding: blink.cmp, mini.pairs, mini.ai
│       ├── colorscheme.lua # Themes: Tokyo Night, Catppuccin
│       ├── editor.lua      # Editor: Telescope, Gitsigns, Treesitter, Which-key
│       ├── ui.lua          # UI: Neo-tree, Lualine, Snacks
│       └── lsp/            # LSP Configuration
│           ├── init.lua    # Base setup (nvim-lspconfig, conform, nvim-lint)
│           ├── python.lua  # Python (Pyright)
│           ├── rust.lua    # Rust (Rust Analyzer)
│           └── ts.lua      # TypeScript (TS LS)
└── lazy-lock.json          # Lockfile
```

## Workflows

### Adding a Plugin
Create a new file in `lua/plugins/` (e.g., `features.lua`) and return the plugin spec:
```lua
return {
  { "username/repo", opts = {} }
}
```

### Adding a Language Server
1.  **Ensure it is installed** via your system package manager (e.g., `npm i -g typescript-language-server`).
2.  Create a new file `lua/plugins/lsp/mylang.lua` (or add to `init.lua` if simple).
3.  Add the `nvim-lspconfig` spec:
    ```lua
    return {
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            mylang_ls = {}, 
          },
        },
      },
    }
    ```

### Keybindings
- **Leader**: `<Space>`
- Use `<Space>sk` to search keymaps via Telescope.
- `which-key` will show available bindings as you type the leader key.

### LSP Keybindings (active when LSP is attached)
| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format buffer |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |
| `]e` / `[e` | Next/prev error |
| `<leader>uh` | Toggle inlay hints |

**TypeScript** (`lsp/ts.lua`):
- `<leader>co` - Organize imports
- `<leader>cR` - Remove unused imports

**Rust** (`lsp/rust.lua`) - requires `rustaceanvim`:
- `<leader>cC` - Open Cargo.toml
- `<leader>cR` - Rust runnables
- `<leader>cD` - Rust debuggables
- `<leader>cm` - Expand macro
- `<leader>ce` - Explain error
- `J` - Join lines

**Python** (`lsp/python.lua`):
- `<leader>co` - Organize imports


