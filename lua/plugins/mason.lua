return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Java / Kotlin
        "jdtls",
        "kotlin-language-server",
        "ktlint",
        "google-java-format",
        "java-test",
        "java-debug-adapter",

        -- Frontend
        "eslint-lsp",
        "typescript-language-server",
        "vue-language-server",
      },
    },
  },
}
