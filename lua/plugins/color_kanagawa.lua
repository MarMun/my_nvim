return {
  -- add scheme
  {
    "rebelot/kanagawa.nvim",
    enabled = true,
    name = "kanagawa",
    priority = 1000,
    opts = {
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },

  -- Configure LazyVim to load scheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
      --- colorscheme = "kanagawa-dragon",
      -- colorscheme = "kanagawa-lotus",
    },
  },
}
