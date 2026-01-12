-- Copilot Language Server - provides NES via sidekick.nvim
-- Enabled conditionally in lsp.lua (requires auth + Node.js)

return {
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
