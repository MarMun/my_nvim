-- change some telescope options and a keymap to browse plugin files
return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      -- vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
      {
        "<leader>fa",
        function() require("telescope.builtin").git_files({ cwd = vim.fn.getcwd() }) end,
        desc = "Find Files All",
      },
      -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({ cwd = vim.fn.getcwd() })
        end,
        desc = "Live Grep",
      },
      -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find In Buffers",
      },
      -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Help Tags",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- to include hidden files
          "--glob=!.git/*", -- Exclude the .git directory
        },
      },
    },
  },
}
