return {
  {
    "neovim/nvim-lspconfig",
    config = function()
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
    end,
  },
}
