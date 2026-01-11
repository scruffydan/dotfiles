-- Copilot Language Server configuration
-- Provides Next Edit Suggestions (NES) via sidekick.nvim
-- Auto-discovered by Neovim 0.11+ from runtimepath/lsp/

return {
  cmd = { "copilot-language-server", "--stdio" },
  filetypes = {}, -- Attach to all filetypes (sidekick manages this)
  root_markers = { ".git" },
  init_options = {
    editorInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = "sidekick.nvim",
      version = "1.0.0",
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
  },
}
