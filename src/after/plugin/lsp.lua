local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'eslint',
	'sumneko_lua'
})

lsp.on_attach(function (client, bufnr)
  local opts = {buffer = bufnr, noremap = true, silent = true}
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
end)

lsp.setup()
