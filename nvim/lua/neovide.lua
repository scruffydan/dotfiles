-- Neovide-specific configuration
-- Only loaded when running in Neovide GUI

if not vim.g.neovide then
  return
end

-- Equivalent to what 'brew shellenv' adds to PATH
local homebrew_path = "/opt/homebrew/bin:/opt/homebrew/sbin:"
vim.env.PATH = homebrew_path .. vim.env.PATH

-- Settings
vim.g.neovide_cursor_animation_length = 0

-- Keymaps
vim.keymap.set('n', '<D-=>', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
end, { desc = 'Zoom in' })

vim.keymap.set('n', '<D-->', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
end, { desc = 'Zoom out' })

vim.keymap.set('n', '<D-0>', function()
  vim.g.neovide_scale_factor = 1.0
end, { desc = 'Reset zoom' })

vim.keymap.set({'n', 'v'}, '<D-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('i', '<D-v>', '<C-r>+', { desc = 'Paste from clipboard' })
vim.keymap.set('c', '<D-v>', '<C-r>+', { desc = 'Paste from clipboard' })
vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('v', '<D-x>', '"+d', { desc = 'Cut to clipboard' })
vim.keymap.set('n', '<D-a>', 'ggVG', { desc = 'Select all' })
