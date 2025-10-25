-- ~/.config/nvim/lua/plugins/n8n-git-memory.lua
return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/n8n-git-memory",
    name = "n8n-git-memory",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("n8n-git-memory").setup({
        -- optional overrides:
        -- worktree_dir = ".n8n-sync",
        -- debounce_ms = 1000,
        -- remote = "origin",
        -- patterns = { "*.ts", "*.tsx", "*.vue", "*.js", "*.json", "*.md", "*.lua" },
      })
    end,
  },
}
