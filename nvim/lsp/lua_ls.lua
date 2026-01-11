-- Lua Language Server configuration

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
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
