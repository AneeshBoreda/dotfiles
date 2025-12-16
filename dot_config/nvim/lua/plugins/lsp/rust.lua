return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure you have rust-analyzer installed globally or in PATH
        rust_analyzer = {
          keys = {
            { "<leader>cC", function() vim.cmd.RustLsp("openCargo") end, desc = "Open Cargo.toml" },
            { "<leader>cD", function() vim.cmd.RustLsp("debuggables") end, desc = "Rust Debuggables" },
            { "<leader>cR", function() vim.cmd.RustLsp("runnables") end, desc = "Rust Runnables" },
            { "<leader>cm", function() vim.cmd.RustLsp("expandMacro") end, desc = "Expand Macro" },
            { "<leader>ce", function() vim.cmd.RustLsp("explainError") end, desc = "Explain Error" },
            { "J", function() vim.cmd.RustLsp("joinLines") end, desc = "Join Lines" },
          },
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Add clippy lints for Rust if using rust-analyzer
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      },
    },
  },
  -- rustaceanvim for enhanced Rust support (provides :RustLsp commands)
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {},
        },
      },
    },
  },
}

