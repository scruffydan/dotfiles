-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI Settings
vim.opt.number = true -- Add line numbers
-- Toggle relative line numbers
vim.keymap.set('n', '<leader>n', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end)
vim.opt.guicursor = ""  -- Prevent cursor from changing when switching modes
vim.opt.conceallevel = 0  -- Don't conceal characters
vim.opt.cursorline = true  -- Highlight current line
vim.opt.scrolloff = 8  -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8  -- Keep 8 columns visible left/right
vim.opt.showmode = false  -- Don't show mode (lualine displays it)
vim.opt.cmdheight = 0  -- Hide command line when not in use
vim.opt.signcolumn = "yes"  -- Always show signcolumn

-- Enable true color only if terminal supports it
if os.getenv("COLORTERM") == "truecolor" or os.getenv("COLORTERM") == "24bit" then
  vim.opt.termguicolors = true
end

-- Split behavior
vim.opt.splitright = true  -- Open vertical splits to the right
vim.opt.splitbelow = true  -- Open horizontal splits below

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to split below' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to split above' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Split creation
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Create horizontal split' })
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Create vertical split' })
vim.keymap.set('n', '<leader>\\', '<C-w>v', { desc = 'Create vertical split' })

-- Tab navigation
vim.keymap.set('n', '<C-n>', 'gt', { desc = 'Next tab' })
vim.keymap.set('n', '<C-p>', 'gT', { desc = 'Previous tab' })

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<Esc>', { desc = 'Send Esc to terminal' })

-- Use system clipboard (fails silently over SSH without clipboard provider)
vim.opt.clipboard = "unnamedplus"

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight the cursor line with a subtle background when entering insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('highlight CursorLine guibg=#1D1E19 ctermbg=236')
  end,
})

-- Remove the cursor line highlight when leaving insert mode
vim.api.nvim_create_autocmd('InsertLeave', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('highlight CursorLine guibg=NONE ctermbg=NONE')
  end,
})

-- Tab settings (2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Text wrapping behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Show invisible characters
vim.opt.listchars = {
  eol = '¬',
  tab = '>·',
  trail = '·',
  extends = '>',
  precedes = '<'
}
vim.opt.list = true

-- Buffer settings
vim.opt.hidden = true  -- Required for operations modifying multiple buffers

-- Performance settings
vim.opt.updatetime = 250  -- Faster completion and git signs
vim.opt.timeoutlen = 300  -- Faster key sequence completion

-- Search settings
vim.opt.ignorecase = true  -- Case insensitive search
vim.opt.smartcase = true   -- Unless uppercase used
vim.opt.incsearch = true   -- Incremental search
vim.opt.hlsearch = true    -- Highlight matches
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })  -- Clear highlights

-- Custom commands for quick tab width switching
-- :T2 switches to 2-space indentation (default for most projects)
-- :T4 switches to 4-space indentation (useful for Python, Java, etc.)
vim.api.nvim_create_user_command('T2', function()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
end, {})

vim.api.nvim_create_user_command('T4', function()
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true
end, {})

-- Add dotfiles nvim directory to runtime path and package path
-- This allows nvim to find plugins and config files in ~/dotfiles/nvim
-- even when nvim is started from a different directory
vim.opt.rtp:prepend(vim.fn.expand('~/dotfiles/nvim'))
package.path = package.path .. ';' .. vim.fn.expand('~/dotfiles/nvim/lua/?.lua')

-- Load plugins
require('plugins')

