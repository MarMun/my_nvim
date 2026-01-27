-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local jdk = vim.fn.system("brew --prefix openjdk@21"):gsub("%s+$", "")
vim.env.JAVA_HOME = jdk
vim.env.PATH = jdk .. "/bin:" .. vim.env.PATH
