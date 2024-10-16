return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").volar.setup({})
    end,
  },
}
