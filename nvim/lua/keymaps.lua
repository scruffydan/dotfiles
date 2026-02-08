-- Keymaps and commands configuration
-- All custom keymaps and user commands are defined here
-- Plugin-specific keymaps are defined in their respective plugin files

-- Tab width commands (:T2, :T4)
local function set_tab_width(width)
  vim.opt.tabstop = width
  vim.opt.softtabstop = width
  vim.opt.shiftwidth = width
  vim.opt.expandtab = true
end
vim.api.nvim_create_user_command('T2', function() set_tab_width(2) end, {})
vim.api.nvim_create_user_command('T4', function() set_tab_width(4) end, {})

-- Toggles (<leader>t*)
vim.keymap.set('n', '<leader>tn', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'Toggle relative line numbers' })

vim.keymap.set('n', '<leader>ts', function()
  vim.wo.spell = not vim.wo.spell
  vim.notify(vim.wo.spell and "Spell: on" or "Spell: off", vim.log.levels.INFO)
end, { desc = 'Toggle spell checking' })

vim.keymap.set('n', '<leader>tW', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Wrap: " .. (vim.wo.wrap and "on" or "off"), vim.log.levels.INFO)
end, { desc = 'Toggle wrap (buffer)' })

vim.keymap.set('n', '<leader>tw', function()
  local next_mode = (vim.g.whitespace_mode % 3) + 1
  require("util").set_whitespace_mode(next_mode)
  local labels = { "Whitespace: default", "Whitespace: all", "Whitespace: off" }
  vim.notify(labels[next_mode], vim.log.levels.INFO)
end, { desc = 'Toggle whitespace display' })

-- Toggle ripgrep mode (respect gitignore vs search all)
if vim.fn.executable("rg") == 1 then
  vim.keymap.set('n', '<leader>tG', function()
    local current = vim.opt.grepprg:get()
    if current:match("%-%-no%-ignore") then
      -- Switch to default (respects .gitignore)
      vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
      vim.notify("Grep: respecting .gitignore", vim.log.levels.INFO)
    else
      -- Switch to all files (ignores .gitignore)
      vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden --no-ignore"
      vim.notify("Grep: searching all files (including gitignored)", vim.log.levels.INFO)
    end
  end, { desc = 'Toggle grep gitignore respect' })
end

-- Completion mode: "blink" | "off"
-- Initialize to blink mode (includes copilot source when available)
vim.g.completion_mode = vim.g.completion_mode or "blink"

-- Helper function to update completion states
local function set_completion_mode(mode)
  vim.g.blink_cmp_enabled = (mode == "blink")
end

-- Initialize blink.cmp state (keymaps.lua loads before blink.lua)
set_completion_mode(vim.g.completion_mode)

-- Toggle completion mode
vim.keymap.set("n", "<leader>tc", function()
  local current = vim.g.completion_mode
  local next_mode = current == "blink" and "off" or "blink"
  vim.g.completion_mode = next_mode
  set_completion_mode(next_mode)
  vim.notify("Completion: " .. next_mode, vim.log.levels.INFO)
end, { desc = "Toggle completion (blink/off)" })

-- Tabs
vim.keymap.set('n', '<leader>T', '<cmd>tabnew<CR>', { desc = 'New tab' })

-- Scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down half page (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up half page (centered)' })

-- Add large j/k motions to the jumplist
-- Motions larger than this threshold are recorded for easy backtracking
local LARGE_MOTION_THRESHOLD = 8

vim.keymap.set('n', 'j', function()
  return vim.v.count > LARGE_MOTION_THRESHOLD and "m'" .. vim.v.count .. 'j' or 'j'
end, { expr = true, desc = "Down with jumplist for large motions" })

vim.keymap.set('n', 'k', function()
  return vim.v.count > LARGE_MOTION_THRESHOLD and "m'" .. vim.v.count .. 'k' or 'k'
end, { expr = true, desc = "Up with jumplist for large motions" })

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<Esc>', { desc = 'Send Esc to terminal' })

-- Yank to system clipboard (deletes stay in internal registers)
vim.keymap.set({'n', 'v'}, 'y', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set('n', 'Y', '"+y$', { desc = 'Yank to end of line to clipboard' })

-- Search
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true, desc = 'Clear search highlights' })

-- Working directory
vim.keymap.set('n', '<leader>cd', function()
  vim.cmd('cd %:h')
  vim.notify(vim.fn.getcwd(), vim.log.levels.INFO)
end, { desc = 'Set global CWD to buffer path' })

-- Quickfix
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { desc = 'Open quickfix list' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { desc = 'Close quickfix window' })
vim.keymap.set('n', '<leader>qC', function()
  vim.fn.setqflist({})
  vim.notify('Quickfix list cleared', vim.log.levels.INFO)
end, { desc = 'Clear quickfix list' })

-- Quickfix navigation
vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })
vim.keymap.set('n', '[Q', vim.cmd.cfirst, { desc = 'First quickfix' })
vim.keymap.set('n', ']Q', vim.cmd.clast, { desc = 'Last quickfix' })
