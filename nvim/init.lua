-- UI Settings
vim.opt.number = true
vim.opt.guicursor = ""  -- Prevent cursor from changing when switching modes
vim.opt.conceallevel = 0  -- Don't conceal characters
vim.cmd('syntax on')  -- Enable syntax highlighting

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
vim.opt.lazyredraw = false  -- Don't use with modern terminals

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

-- Keymappings (FZF keymap moved to lazy loading config in plugins.lua)
vim.keymap.set('n', '<F5>', vim.lsp.buf.hover, { noremap = true, silent = true, desc = "LSP Hover" })

-- Add dotfiles nvim lua directory to package path
package.path = package.path .. ';' .. vim.fn.expand('~/dotfiles/nvim/lua/?.lua')

-- Load plugins
require('plugins')
