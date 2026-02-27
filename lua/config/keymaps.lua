-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- shortcuts
vim.keymap.set("n", "<leader>w", vim.cmd.w, { desc = "Save Buffer" })
vim.keymap.set("n", "<leader>e", vim.cmd.q, { desc = "Quit Buffer" })
vim.keymap.set("n", "<leader>we", ":wq<CR>", { desc = "Save & Quit Buffer" })
vim.keymap.set("i", "jj", "<ESC>", { desc = "End Insert mode" })

-- terminal mode - escape to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "tt", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- open pi in vertical terminal split
vim.keymap.set("n", "<leader>pi", ":vsplit | term pi<CR>i", { desc = "Open pi in vertical terminal" })

-- open message history horizontal split
vim.keymap.set("n", "<leader>mm", ":Noice history<CR>", { desc = "Notify history" })

-- tabs
vim.keymap.set("n", "<leader>tc", vim.cmd.tabnew, { desc = "Tab new" })
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnext, { desc = "Tab next" })
vim.keymap.set("n", "<leader>tp", vim.cmd.tabprevious, { desc = "Tab previous" })
vim.keymap.set("n", "<leader>td", vim.cmd.tabclose, { desc = "Tab close" })

-- undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree toggle" })

-- Ollama - Direct prompting
vim.keymap.set(
  "n",
  "<leader>og",
  ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
  { desc = "Ollama Generate_Code" }
)

-- Ollama - Custom Prompt test
vim.keymap.set(
  { "n", "v" },
  "<leader>ol",
  ":<c-u>lua require('ollama').prompt('Language_Identifier')<cr>",
  { desc = "Ollama Prompt" }
)

-- Ollama - Prompt menu
vim.keymap.set({ "n", "v" }, "<leader>oo", ":<c-u>lua require('ollama').prompt()<cr>", { desc = "Ollama Prompt" })
