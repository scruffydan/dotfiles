-- Bash Language Server configuration
-- Uses shellcheck for diagnostics
-- Auto-discovered by Neovim 0.11+ from runtimepath/lsp/

return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
}
