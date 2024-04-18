vim.g.mapleader = ","

-- shortcuts
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>e", vim.cmd.q)
vim.keymap.set("n", "<leader>we", ':wq<CR>')
vim.keymap.set("i", "jj", "<ESC>")

-- terminal emulator
vim.keymap.set("n", "<leader>tt", "<C-w><C-v>:term<CR>")
vim.keymap.set("t", "jj", "<C-\\><C-n>")

-- edit helper
--- replace current word with yank
vim.keymap.set("n", "<leader>S", '"_diwP')
vim.keymap.set("n", "<leader>ml", 'ciw[<ESC>pa]()<ESC>ha')

-- disable search highlight
vim.keymap.set("n", "//", vim.cmd.nohlsearch)

-- buffer navigation
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-l>", "<C-W>l")

-- tabs
vim.keymap.set("n", "<leader>tc", vim.cmd.tabnew)
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnext)
vim.keymap.set("n", "<leader>tp", vim.cmd.tabprevious)
vim.keymap.set("n", "<leader>td", vim.cmd.tabclose)

-- undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

