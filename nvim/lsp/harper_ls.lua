-- Harper Language Server configuration
-- Grammar checker for comments and markdown

vim.lsp.config("harper_ls", {
  settings = {
    ["harper-ls"] = {
      userDictPath = vim.g.dotfiles_nvim .. "/spell/en.utf-8.add",
      linters = {
        SentenceCapitalization = false,
      },
      diagnosticSeverity = "hint",
      dialect = "American",
    },
  },
})
