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

-- Toggle Harper grammar checker
vim.keymap.set("n", "<leader>th", function()
  local clients = vim.lsp.get_clients({ name = "harper_ls" })
  if #clients > 0 then
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end
    vim.notify("Harper disabled", vim.log.levels.INFO)
  else
    vim.cmd("LspStart harper_ls")
    vim.notify("Harper enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Harper grammar checker" })
