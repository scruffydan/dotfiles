-- Shared utility functions for neovim config
local M = {}

-- Check if copilot-language-server is installed (required for NES and copilot.vim)
function M.copilot_available()
  return vim.fn.executable("copilot-language-server") == 1
end

-- Set whitespace display mode
-- mode 1: default (eol, tab, trail)
-- mode 2: all spaces visible
-- mode 3: off
function M.set_whitespace_mode(mode)
  vim.g.whitespace_mode = mode
  if mode == 1 then
    vim.opt.listchars = {
      eol = '¬',
      tab = '>·',
      trail = '·',
      extends = '>',
      precedes = '<',
      -- lead = '·'
    }
    vim.opt.list = true
    vim.g.snacks_indent = true
  elseif mode == 2 then
    vim.opt.listchars = {
      eol = '¬',
      tab = '>·',
      trail = '·',
      extends = '>',
      precedes = '<',
      lead = '·',
      space = '·'
    }
    vim.opt.list = true
    vim.g.snacks_indent = true
  else
    vim.opt.list = false
    vim.g.snacks_indent = false
  end
  -- Refresh snacks indent if available
  pcall(function() require('snacks.indent').enable() end)
end

return M
