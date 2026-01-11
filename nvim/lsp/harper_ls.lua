-- Harper Language Server configuration
-- Grammar checker for comments and markdown
-- Auto-discovered by Neovim 0.11+ from runtimepath/lsp/

return {
  cmd = { "harper-ls", "--stdio" },
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
