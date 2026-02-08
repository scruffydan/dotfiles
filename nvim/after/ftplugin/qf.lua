-- Quickfix list ftplugin
-- Adds functionality to delete items from the quickfix list

vim.keymap.set("n", "dd", function()
  local qf_list = vim.fn.getqflist()  -- Get the current quickfix list
  local line = vim.fn.line(".")       -- Get current cursor line

  -- Check if there's an item at the current line
  if not qf_list[line] then
    return
  end

  table.remove(qf_list, line)         -- Remove the item at current line
  vim.fn.setqflist(qf_list, "r")      -- Replace quickfix list with modified one

  -- Close quickfix window if empty, otherwise reposition cursor
  if #qf_list == 0 then
    vim.cmd.cclose()
  else
    vim.fn.cursor(math.min(line, #qf_list), 1)
  end
end, { buffer = true, silent = true, desc = "Delete quickfix item" })
