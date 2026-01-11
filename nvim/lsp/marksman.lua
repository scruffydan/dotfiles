-- Marksman Markdown Language Server
-- Auto-discovered by Neovim 0.11+ from runtimepath/lsp/

return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_markers = { ".marksman.toml", ".git" },
}
