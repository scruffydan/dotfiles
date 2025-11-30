-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin specifications from plugins/ directory
local plugins = {
  require("plugins.theme"),
  require("plugins.telescope"),
  require("plugins.nvim-tree"),
  require("plugins.oil"),
  require("plugins.autopairs"),
  require("plugins.which-key"),
  require("plugins.lualine"),
  require("plugins.gitsigns"),
  require("plugins.render-markdown"),
  require("plugins.treesitter"),
}

require("lazy").setup(plugins)
