-- Shared utility functions for neovim config
local M = {}

-- Check if copilot-language-server is installed (required for NES and copilot.vim)
function M.copilot_available()
  return vim.fn.executable("copilot-language-server") == 1
end

return M
