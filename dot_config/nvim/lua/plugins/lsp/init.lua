return {
  -- lspconfig (still needed for server definitions, but using new native API)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      -- Server configurations
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Configure diagnostics
      vim.diagnostic.config(opts.diagnostics)
      
      -- Get blink.cmp capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      -- Use modern vim.lsp.config() API for each server
      for server, config in pairs(opts.servers) do
        -- Merge capabilities
        config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
        
        -- Define server config using native API
        vim.lsp.config(server, config)
      end
      
      -- Enable all configured servers
      vim.lsp.enable(vim.tbl_keys(opts.servers))
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
      },
    },
  },
  
  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        markdown = { "markdownlint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      
      local ns = vim.api.nvim_create_namespace("lint")
      vim.api.nvim_create_autocmd(opts.events, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  }
}
