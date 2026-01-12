-- Lua Language Server - configured for Neovim development
-- Extends nvim-lspconfig defaults with custom settings

return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "vim", "Snacks" },
      },
    },
  },
}
