-- Lua Language Server configuration

vim.lsp.config("lua_ls", {
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
        enable = true,
      },
    },
  },
})

-- Enable lua_ls for Lua files
vim.lsp.enable("lua_ls")
