-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
-- Auto-load all plugin specs from plugins/ directory and theme.lua
local plugins = { require("theme") }

local plugins_dir = vim.g.dotfiles_nvim .. "/lua/plugins"
for _, file in ipairs(vim.fn.readdir(plugins_dir)) do
  if file:match("%.lua$") then
    local module_name = file:gsub("%.lua$", "")
    plugins[#plugins + 1] = require("plugins." .. module_name)
  end
end

require("lazy").setup(plugins, {
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      -- Add dotfiles paths to runtimepath (lazy.nvim rebuilds rtp, so we must add here)
      -- - Base dir: enables lsp/*.lua discovery for vim.lsp.enable()
      -- - after/: enables ftplugin/*.lua for filetype-specific settings
      -- Note: lazy.nvim only auto-handles after/ for plugins it manages, not custom paths
      paths = { vim.g.dotfiles_nvim, vim.g.dotfiles_nvim .. "/after" },
    },
  },
})
