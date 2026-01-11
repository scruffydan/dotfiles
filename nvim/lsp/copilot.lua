-- Copilot Language Server configuration
-- Provides Next Edit Suggestions (NES) via sidekick.nvim
-- Auto-discovered by Neovim 0.11+ from runtimepath/lsp/

return {
  cmd = { "copilot-language-server", "--stdio" },
  init_options = {
    editorInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = "sidekick.nvim",
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
  },
}
