-- Harper Language Server configuration
-- Grammar checker for comments and markdown

vim.lsp.config("harper_ls", {
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
})

-- Enable Harper by default
vim.g.harper_enabled = true
vim.lsp.enable("harper_ls")

-- Toggle Harper grammar checker globally
vim.keymap.set("n", "<leader>th", function()
  vim.g.harper_enabled = not vim.g.harper_enabled
  vim.lsp.enable("harper_ls", vim.g.harper_enabled)
  vim.notify("Harper " .. (vim.g.harper_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle Harper grammar checker" })
