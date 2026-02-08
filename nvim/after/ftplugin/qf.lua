vim.keymap.set("n", "dd", function()
  local qf_list = vim.fn.getqflist()
  local line = vim.fn.line(".")
  if not qf_list[line] then
    return
  end
  table.remove(qf_list, line)
  vim.fn.setqflist(qf_list, "r")
  if #qf_list == 0 then
    vim.cmd.cclose()
  else
    vim.fn.cursor(math.min(line, #qf_list), 1)
  end
end, { buffer = true, silent = true, desc = "Delete quickfix item" })
