-- Shared utility functions for neovim config
local M = {}

-- Platform detection
local sysname = vim.uv.os_uname().sysname:lower()
M.platform = sysname
M.is_mac = sysname == "darwin"
M.is_linux = sysname == "linux"
M.is_freebsd = sysname == "freebsd"
M.is_windows = sysname:match("windows") ~= nil

-- Tool availability (cached at require time)
M.has_npm = vim.fn.executable("npm") == 1

-- Check if copilot-language-server is installed (Node.js is implied)
function M.copilot_available()
  return vim.fn.executable("copilot-language-server") == 1
end

-- Set whitespace display mode
-- mode 1: default (eol, tab, trail)
-- mode 2: all spaces visible
-- mode 3: off
function M.set_whitespace_mode(mode)
  vim.g.whitespace_mode = mode
  local base_chars = {
    eol = '¬',
    tab = '>·',
    trail = '·',
    extends = '>',
    precedes = '<',
  }
  if mode == 1 then
    vim.opt.listchars = base_chars
    vim.opt.list = true
    vim.g.snacks_indent = true
  elseif mode == 2 then
    vim.opt.listchars = vim.tbl_extend("force", base_chars, { lead = '·', space = '·' })
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
