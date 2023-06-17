vim.g.mapleader = ","

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>e", vim.cmd.q)
vim.keymap.set("n", "<leader>we", ':wq<CR>')

vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("n", "//", vim.cmd.nohlsearch)

vim.keymap.set("n", "<S-h>", "<C-W>h")
vim.keymap.set("n", "<S-j>", "<C-W>j")
vim.keymap.set("n", "<S-k>", "<C-W>k")
vim.keymap.set("n", "<S-l>", "<C-W>l")

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

