return {
  {
    "huggingface/llm.nvim",
    dependencies = { "huggingface/llm-ls" },
    config = function()
      require("llm").setup({
        -- Add your configuration here if needed
        model = "codellama:7b",
        backend = "ollama",
        url = "http://localhost:11434", -- llm-ls uses "/api/generate"
        -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
        lsp = {
          bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
        },
        request_body = {
          -- Modelfile options for the model you use
          options = {
            temperature = 0.2,
            top_p = 0.95,
          },
        },
      })
    end,
  },
}
