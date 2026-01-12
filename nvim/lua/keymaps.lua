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

-- Completion mode: "copilot" | "native" | "off"
-- Initialize to copilot mode (will be adjusted by toggle if copilot not available)
vim.g.completion_mode = vim.g.completion_mode or "copilot"

-- Helper function to update completion states
local function set_completion_mode(mode)
  if mode == "copilot" then
    vim.g.copilot_enabled = true
    vim.g.minicompletion_disable = true
  elseif mode == "native" then
    vim.g.copilot_enabled = false
    vim.g.minicompletion_disable = false
  else -- off
    vim.g.copilot_enabled = false
    vim.g.minicompletion_disable = true
  end
end

-- Initialize copilot and mini.completion states based on completion mode
set_completion_mode(vim.g.completion_mode)

-- Toggle completion mode
vim.keymap.set("n", "<leader>tc", function()
  local copilot_available = require("util").copilot_available
  local modes = copilot_available() and { "copilot", "native", "off" } or { "native", "off" }
  local current = vim.g.completion_mode
  
  local idx = 1
  for i, mode in ipairs(modes) do
    if mode == current then
      idx = i
      break
    end
  end
  
  local next_mode = modes[(idx % #modes) + 1]
  vim.g.completion_mode = next_mode
  set_completion_mode(next_mode)

  vim.notify("Completion: " .. next_mode, vim.log.levels.INFO)
end, { desc = "Cycle completion (copilot/native/off)" })

-- Tabs
vim.keymap.set('n', '<leader>T', '<cmd>tabnew<CR>', { desc = 'New tab' })

-- Scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down half page (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up half page (centered)' })

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
