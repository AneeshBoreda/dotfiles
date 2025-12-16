-- Rust support via rustaceanvim (manages rust-analyzer itself)
-- Does NOT use nvim-lspconfig for rust-analyzer
--
-- vim.g.rustaceanvim MUST be set in init (before plugin loads), not config
return {
  {
    "mrcjkb/rustaceanvim",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- Standard LSP keymaps
            map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
            map("n", "gr", vim.lsp.buf.references, "References")
            map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
            map("n", "gI", vim.lsp.buf.implementation, "Go to Implementation")
            map("n", "gy", vim.lsp.buf.type_definition, "Go to Type Definition")
            map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
            map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
            map({ "n", "v" }, "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, "Code Action")
            map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
            map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
            map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
            map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
            map("n", "]e", function()
              vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
            end, "Next Error")
            map("n", "[e", function()
              vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
            end, "Prev Error")

            -- K - Use rustaceanvim's enhanced hover
            map("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, "Hover Actions")

            -- Format
            map({ "n", "v" }, "<leader>cf", function()
              local ok, conform = pcall(require, "conform")
              if ok then
                conform.format({ bufnr = bufnr })
              else
                vim.lsp.buf.format({ bufnr = bufnr })
              end
            end, "Format")

            -- Toggle inlay hints
            if client.supports_method("textDocument/inlayHint") then
              map("n", "<leader>uh", function()
                vim.lsp.inlay_hint.enable(
                  not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                  { bufnr = bufnr }
                )
              end, "Toggle Inlay Hints")
            end

            -- Rust-specific keymaps
            map("n", "<leader>cC", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
            map("n", "<leader>cD", function() vim.cmd.RustLsp("debuggables") end, "Rust Debuggables")
            map("n", "<leader>cR", function() vim.cmd.RustLsp("runnables") end, "Rust Runnables")
            map("n", "<leader>cm", function() vim.cmd.RustLsp("expandMacro") end, "Expand Macro")
            map("n", "<leader>ce", function() vim.cmd.RustLsp("explainError") end, "Explain Error")
            map("n", "J", function() vim.cmd.RustLsp("joinLines") end, "Join Lines")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },
}
