-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI Settings
vim.opt.number = true -- Add line numbers
vim.opt.relativenumber = true -- Show relative line numbers
-- Toggle relative line numbers
vim.keymap.set('n', '<leader>tn', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'Toggle relative line numbers' })
-- Toggle spell checking
vim.keymap.set('n', '<leader>ts', function()
  vim.wo.spell = not vim.wo.spell
  vim.notify(vim.wo.spell and "Spell: on" or "Spell: off", vim.log.levels.INFO)
end, { desc = 'Toggle spell checking' })
-- Spell file location
vim.opt.spellfile = vim.fn.expand('~/dotfiles/nvim/spell/en.utf-8.add')
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

-- Neovide-specific settings
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  -- Cmd+= to zoom in, Cmd+- to zoom out, Cmd+0 to reset
  vim.keymap.set('n', '<D-=>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end)
  vim.keymap.set('n', '<D-->', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
  end)
  vim.keymap.set('n', '<D-0>', function()
    vim.g.neovide_scale_factor = 1.0
  end)
  -- Cmd+V to paste from system clipboard
  vim.keymap.set({'n', 'v'}, '<D-v>', '"+p', { desc = 'Paste from clipboard' })
  vim.keymap.set('i', '<D-v>', '<C-r>+', { desc = 'Paste from clipboard' })
  vim.keymap.set('c', '<D-v>', '<C-r>+', { desc = 'Paste from clipboard' })
  -- Cmd+C to copy to system clipboard
  vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy to clipboard' })
  -- Cmd+X to cut to system clipboard
  vim.keymap.set('v', '<D-x>', '"+d', { desc = 'Cut to clipboard' })
  -- Cmd+A to select all
  vim.keymap.set('n', '<D-a>', 'ggVG', { desc = 'Select all' })
end

-- Tabs
vim.keymap.set('n', '<leader>T', '<cmd>tabnew<CR>', { desc = 'New tab' })

-- Split behavior
vim.opt.splitright = true  -- Open vertical splits to the right
vim.opt.splitbelow = true  -- Open horizontal splits below

-- Split navigation handled by vim-tmux-navigator plugin
-- vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
-- vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to split below' })
-- vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to split above' })
-- vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Split creation
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Create horizontal split' })
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Create vertical split' })
vim.keymap.set('n', '<leader>\\', '<C-w>v', { desc = 'Create vertical split' })

-- Keep cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down half page (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up half page (centered)' })

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<Esc>', { desc = 'Send Esc to terminal' })

-- Use system clipboard (fails silently over SSH without clipboard provider)
vim.opt.clipboard = "unnamedplus"




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
vim.g.whitespace_mode = 1

local function set_whitespace_mode(mode)
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

-- Initialize with default mode
set_whitespace_mode(1)

-- Toggle whitespace display
vim.keymap.set('n', '<leader>tw', function()
  local next_mode = (vim.g.whitespace_mode % 3) + 1
  set_whitespace_mode(next_mode)
  local labels = { "Whitespace: default", "Whitespace: all", "Whitespace: off" }
  vim.notify(labels[next_mode], vim.log.levels.INFO)
end, { desc = 'Toggle whitespace display' })

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

-- Folding with treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99  -- Start with all folds open
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldtext = ""  -- Show first line of fold as-is

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
require('lazy-setup')

-- Completion mode: "copilot" | "native" | "off"
-- Default to copilot inline completions (if available)
local function copilot_available()
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then return false end
  local plugin = lazy_config.plugins["copilot.vim"]
  return plugin and plugin._.cond ~= false
end

-- Initialize completion mode: preserve existing value, or default to "copilot" if available, else "native"
vim.g.completion_mode = vim.g.completion_mode or (copilot_available() and "copilot" or "native")

-- Disable mini.completion by default when in copilot mode
if vim.g.completion_mode == "copilot" then
  vim.g.minicompletion_disable = true
end

-- Toggle completion mode: copilot -> native -> off -> copilot
-- (skips copilot if node not available)
vim.keymap.set("n", "<leader>tc", function()
  local modes = copilot_available() and { "copilot", "native", "off" } or { "native", "off" }
  local current = vim.g.completion_mode or "copilot"
  local idx = 1
  for i, mode in ipairs(modes) do
    if mode == current then
      idx = i
      break
    end
  end
  local next_mode = modes[(idx % #modes) + 1]
  vim.g.completion_mode = next_mode

  -- Update copilot and mini.completion states
  if next_mode == "copilot" then
    vim.g.copilot_enabled = true
    vim.g.minicompletion_disable = true
  elseif next_mode == "native" then
    vim.g.copilot_enabled = false
    vim.g.minicompletion_disable = false
  else -- off
    vim.g.copilot_enabled = false
    vim.g.minicompletion_disable = true
  end

  vim.notify("Completion: " .. next_mode, vim.log.levels.INFO)
end, { desc = "Cycle completion (copilot/native/off)" })

