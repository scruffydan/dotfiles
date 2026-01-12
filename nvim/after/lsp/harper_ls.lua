-- Harper Language Server - grammar checker for comments and markdown
-- Extends nvim-lspconfig defaults with custom settings

return {
  settings = {
    ["harper-ls"] = {
      userDictPath = vim.g.dotfiles_nvim .. "/spell/en.utf-8.add",
      linters = {
        SentenceCapitalization = false,
        SpellCheck = false,
      },
      diagnosticSeverity = "hint",
      dialect = "American",
    },
  },
}
