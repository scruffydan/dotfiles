-- Basic Settings
vim.opt.number = true

-- Tab settings (2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Text wrapping behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false  -- This would interfere with linebreak
vim.opt.breakindent = true

-- Prevent cursor from changing when switching modes
vim.opt.guicursor = ""

-- Required for operations modifying multiple buffers like rename
vim.opt.hidden = true

-- Show invisible characters
vim.opt.listchars = {
  eol = '¬',
  tab = '>·',
  trail = '·',
  extends = '>',
  precedes = '<'
}
vim.opt.list = true

-- Don't conceal characters
vim.opt.conceallevel = 0

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Custom commands for tab width switching
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

-- Allow saving of files as sudo when I forgot to start vim using sudo
vim.api.nvim_create_user_command('W', function()
  vim.cmd('silent w !sudo tee % > /dev/null')
  vim.cmd('edit!')
end, {})

-- Keymappings
vim.keymap.set('n', '<C-p>', ':FZF<CR>', { noremap = true })
vim.keymap.set('n', '<F5>', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

-- Load plugins
require('plugins')
