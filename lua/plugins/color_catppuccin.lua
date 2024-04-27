-- vim.g.catppuccin_flavour = "frappe"
-- vim.g.catppuccin_flavour = "latte"
-- vim.g.catppuccin_flavour = "mocha"
-- vim.g.catppuccin_flavour = "macchiato"

return {
  -- add scheme
  { "catppuccin/nvim", enabled = false, name = "catppuccin", priority = 1000 },

  -- Configure LazyVim to load scheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
