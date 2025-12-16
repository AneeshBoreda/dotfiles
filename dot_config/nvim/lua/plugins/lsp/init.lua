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
      
      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(event)
          local buffer = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
          end
          
          -- Standard LSP keymaps
          map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
          map("n", "gI", vim.lsp.buf.implementation, "Go to Implementation")
          map("n", "gy", vim.lsp.buf.type_definition, "Go to Type Definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
          map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
          map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
          map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next Error")
          map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Prev Error")
          
          -- Format keymap (uses conform if available, fallback to LSP)
          map({ "n", "v" }, "<leader>cf", function()
            local ok, conform = pcall(require, "conform")
            if ok then
              conform.format({ bufnr = buffer })
            else
              vim.lsp.buf.format({ bufnr = buffer })
            end
          end, "Format")
          
          -- Toggle inlay hints if supported
          if client and client.supports_method("textDocument/inlayHint") then
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }), { bufnr = buffer })
            end, "Toggle Inlay Hints")
          end
          
          -- Register server-specific keys
          if client then
            local server_config = opts.servers[client.name]
            if server_config and server_config.keys then
              for _, keymap in ipairs(server_config.keys) do
                local mode = keymap.mode or "n"
                vim.keymap.set(mode, keymap[1], keymap[2], {
                  buffer = buffer,
                  desc = keymap.desc,
                })
              end
            end
          end
        end,
      })
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
