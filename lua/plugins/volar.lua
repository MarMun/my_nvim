return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").volar.setup({
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })
      require("lspconfig").eslint.setup({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      })
    end,
  },
}
