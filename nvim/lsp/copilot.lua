-- Copilot Language Server configuration for NES (Next Edit Suggestions)
-- Inline completions are handled by github/copilot.vim plugin
-- Install with :MasonInstall copilot-language-server

-- Requires copilot-language-server; skip if not available
if vim.fn.executable("copilot-language-server") ~= 1 then
  return {}
end

return {
  cmd = { 'copilot-language-server', '--stdio' },
  root_markers = { '.git' },
  init_options = {
    editorInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = 'off',
    },
  },
}
