-- Copilot Language Server configuration for NES (Next Edit Suggestions)
-- Inline completions are handled by github/copilot.vim plugin
-- Sign in with :Copilot auth (via copilot.vim), then restart Neovim

-- Requires copilot-language-server; skip if not available
if vim.fn.executable("copilot-language-server") ~= 1 then
  return {}
end

-- Skip if not authenticated (use :Copilot auth to sign in, then restart)
local copilot_config_dir = vim.fn.expand("~/.config/github-copilot")
if vim.fn.isdirectory(copilot_config_dir) ~= 1 then
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
