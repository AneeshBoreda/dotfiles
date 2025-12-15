-- 🎨 Active colorscheme - change this to switch themes
local active = "molokai"

-- Helper function to apply colorscheme only if it's the active one
local function apply_if_active(name)
  return function()
    if name == active then
      vim.cmd.colorscheme(name)
    end
  end
end

return {
  {
    "tomasr/molokai",
    lazy = false,
    priority = 1000,
    config = apply_if_active("molokai"),
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "moon" },
    config = apply_if_active("tokyonight"),
  },
}
