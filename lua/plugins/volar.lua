return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "tsserver", -- correct name (was "ts_ls" → wrong!)
        "eslint",
        "volar",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Volar
      lspconfig.volar.setup({
        filetypes = { "vue" },
      })

      -- ESLint
      lspconfig.eslint.setup({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        on_attach = function(client, bufnr)
          if client.server_capabilities.codeActionProvider then
            local group = vim.api.nvim_create_augroup("LspESLintAutoFix", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end
        end,
      })

      -- TypeScript
      lspconfig.tsserver.setup({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,
  },
}
