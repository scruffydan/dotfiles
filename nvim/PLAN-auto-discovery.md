# Auto-Discovery for Plugins and LSPs

This plan updates the Neovim config to use auto-discovery instead of manual sourcing.

## Problem

Currently both plugins and LSP configs require manual listing:
- `lazy-setup.lua`: Each plugin must be explicitly `require()`d
- `lsp-config.lua`: Each LSP server must be listed in `lsp_servers` table and loaded via `dofile()`

## Solution

### 1. Lazy Plugin Auto-Discovery

Change `lazy-setup.lua` to use Lazy's `import` feature:

```lua
-- Before: Manual list of 18+ plugins
local plugins = {
  require("theme"),
  require("plugins.oil"),
  require("plugins.mini"),
  -- ... etc
}
require("lazy").setup(plugins, { ... })

-- After: Auto-discover from lua/plugins/
require("lazy").setup({
  spec = {
    { import = "theme" },
    { import = "plugins" },
  },
  ui = {
    border = "rounded",
  },
})
```

This works because `~/dotfiles/nvim` is already prepended to `rtp` and `package.path` in init.lua.

### 2. LSP Auto-Discovery

Change `lsp-config.lua` to enable all discovered LSP configs:

```lua
-- Before: Manual list
local lsp_servers = {
  "lua_ls",
  "copilot", 
  "harper_ls",
}
for _, server in ipairs(lsp_servers) do
  local lsp_path = vim.g.dotfiles_nvim .. '/lsp/' .. server .. '.lua'
  if vim.fn.filereadable(lsp_path) == 1 then
    dofile(lsp_path)
  end
end

-- After: Enable all discovered configs
vim.lsp.enable(vim.tbl_keys(vim.lsp.config))
```

Neovim 0.11+ auto-discovers configs from `lsp/` directories in runtimepath.

## Files to Modify

1. `nvim/lua/lazy-setup.lua` - Use `import` instead of manual requires
2. `nvim/lua/lsp-config.lua` - Use `vim.lsp.enable()` for all discovered configs

## Benefits

- Adding a new plugin: Just create a file in `lua/plugins/`
- Adding a new LSP: Just create a file in `lsp/`
- No need to update any config lists
