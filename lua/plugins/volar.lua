return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" }, -- Add mason-lspconfig as a dependency
    config = function()
      -- Ensure key language servers like tsserver are installed using mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver", -- TypeScript language server
          "eslint", -- ESLint language server
          "volar", -- Volar for Vue files
        },
      })

      -- Volar setup for Vue files only
      require("lspconfig").volar.setup({
        filetypes = { "vue" }, -- Restrict to Vue files only
      })

      -- ESLint setup with auto-fix on save
      require("lspconfig").eslint.setup({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }, -- Add Vue as well
        on_attach = function(client, bufnr)
          if client.server_capabilities.codeActionProvider then
            -- Create a group to manage ESLint autocmds
            local group = vim.api.nvim_create_augroup("LspESLintAutoFix", { clear = true })

            -- Auto-fix ESLint issues on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = bufnr,
              command = "EslintFixAll", -- Run ESLint's fix command on save
            })
          end
        end,
      })

      -- TypeScript setup
      require("lspconfig").tsserver.setup({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        on_attach = function(client, bufnr)
          -- Disable formatting in tsserver to prevent conflicts with prettier/eslint
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,
  },
}
