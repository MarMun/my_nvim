-- Configure Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust-analyzer", "lua-language-server" },
})

-- Import the necessary modules
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Set up capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Configure rust-analyzer
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        features = { "default" }, -- default features
      },
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
})

function SwitchRustFeatures(features)
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

  lspconfig.rust_analyzer.setup({
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = features,
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Your custom on_attach function (optional)
    end,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  })

  -- Restart Rust Analyzer to apply changes
  vim.cmd("LspRestart")
end

-- Command to switch Rust features
vim.cmd([[
  command! -nargs=1 RustFeatures lua SwitchRustFeatures({<f-args>})
]])

print("rust config loaded")
