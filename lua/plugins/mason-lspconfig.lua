-- Don't let mason start a second rust_analyzer client
-- If we don't do this, :LspInfo shows two clients
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      rust_analyzer = function()
        return true
      end,
    },
  },
}
