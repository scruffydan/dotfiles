-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Plugin specifications
require("lazy").setup({
  -- Theme
  {
    "scruffydan/submonokai-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme submonokai')
    end,
  },

  -- FZF fuzzy finder
  {
    "junegunn/fzf",
    build = function()
      vim.fn.system("./install --all")
    end,
    dir = "~/.fzf",
    lazy = true,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<C-p>", ":FZF<CR>", desc = "Open FZF" },
    },
  },

  -- Treesitter (handles syntax highlighting, replaces vim-javascript)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "javascript", "typescript", "lua", "vim", "vimdoc", "json", "html", "css" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- Uncomment if you want to use coc.nvim
  -- {
  --   "neoclide/coc.nvim",
  --   branch = "release",
  -- },

  -- Uncomment if you want indent lines
  -- "Yggdroot/indentLine",
})
