-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Centralized dotfiles path
vim.g.dotfiles_nvim = vim.fn.expand('~/dotfiles/nvim')

-- Add dotfiles nvim directory to runtime path and package path
-- This allows nvim to find plugins and config files in ~/dotfiles/nvim
-- even when nvim is started from a different directory
vim.opt.rtp:prepend(vim.g.dotfiles_nvim)
vim.opt.rtp:append(vim.g.dotfiles_nvim .. '/after')
package.path = package.path .. ';' .. vim.g.dotfiles_nvim .. '/lua/?.lua'

-- UI Settings
vim.opt.number = true -- Add line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.spell = true -- Enable spell checking by default
vim.opt.spellfile = vim.g.dotfiles_nvim .. '/spell/en.utf-8.add'
vim.opt.spelllang = "en_us" -- Set spellcheck language

vim.opt.guicursor = ""  -- Prevent cursor from changing when switching modes
vim.opt.conceallevel = 0  -- Don't conceal characters
vim.opt.cursorline = true  -- Highlight current line
vim.opt.scrolloff = 8  -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8  -- Keep 8 columns visible left/right
vim.opt.signcolumn = "yes"  -- Always show signcolumn
if vim.fn.has("nvim-0.12") == 1 then -- Checks if nvim is version 0.12 or greater
  vim.opt.pumborder = "rounded"  -- Rounded border on completion popup
end

-- Enable true color only if terminal supports it
if os.getenv("COLORTERM") == "truecolor" or os.getenv("COLORTERM") == "24bit" then
  vim.opt.termguicolors = true
end

-- GUI font for Neovide (and other GUI clients)
vim.opt.guifont = "SauceCodePro NFM:h14"

-- Split behavior
vim.opt.splitright = true  -- Open vertical splits to the right
vim.opt.splitbelow = true  -- Open horizontal splits below

-- Split navigation handled by vim-tmux-navigator plugin

-- Tab settings (2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Text wrapping behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Whitespace display modes (toggle with <leader>tw)
-- 1 = default (lead/trail/tab/eol), 2 = all spaces, 3 = off
require("util").set_whitespace_mode(1)

-- Performance settings
vim.opt.updatetime = 250  -- Faster completion and git signs
vim.opt.timeoutlen = 300  -- Faster key sequence completion

-- Search settings
vim.opt.ignorecase = true  -- Case insensitive search
vim.opt.smartcase = true   -- Unless uppercase used
vim.opt.incsearch = true   -- Incremental search
vim.opt.hlsearch = true    -- Highlight matches

-- Folding with treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99  -- Start with all folds open
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldtext = ""  -- Show first line of fold as-is

-- Load keymaps and commands
require('keymaps')

-- Load Neovide configuration
require('neovide')

-- Load plugins
require('lazy-setup')

-- Load LSP configuration
require('lsp')

