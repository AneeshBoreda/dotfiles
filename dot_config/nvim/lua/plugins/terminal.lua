local float_opts = {
  win = {
    position = "float",
    backdrop = 60,
    height = 0.9,
    width = 0.9,
    zindex = 50,
    border = "rounded",
  },
}

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<2-c-/>",
        function()
          Snacks.terminal.toggle(nil, float_opts)
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },
      {
        "<c-/>",
        function()
          Snacks.terminal.toggle(nil, float_opts)
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },
      {
        "<c-_>", -- For terminals that send <c-_> on <c-/>
        function()
          Snacks.terminal.toggle(nil, float_opts)
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {}, -- Global overrides removed to prevent pollution of split terminals
    keys = {
      {
        "<leader>tf",
        function()
          Snacks.terminal.toggle(nil, float_opts)
        end,
        desc = "Toggle Terminal (Float)",
      },
      {
        "<leader>ts",
        function()
          vim.cmd("split")
          vim.cmd("term")
          vim.cmd("startinsert")
        end,
        desc = "Terminal (Horizontal Split)",
      },
      {
        "<leader>tv",
        function()
          vim.cmd("vsplit")
          vim.cmd("term")
          vim.cmd("startinsert")
        end,
        desc = "Terminal (Vertical Split)",
      },
      {
        "<leader>tt",
        function()
          vim.cmd("tabnew")
          vim.cmd("term")
          vim.cmd("startinsert")
        end,
        desc = "Terminal (New Tab)",
      },
      {
        "<c-[>",
        "<c-\\><c-n>",
        desc = "Exit Terminal Mode",
        mode = "t",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>t", group = "terminal" })
    end,
  },
}
