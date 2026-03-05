-- Automatic bullet point continuation for markdown and text files
return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "text" },
  init = function()
    -- Disable default <CR> mapping - we'll handle it ourselves
    vim.g.bullets_set_mappings = 0
    vim.g.bullets_custom_mappings = {
      { "nmap", "o", "<Plug>(bullets-newline)" },
      { "vmap", "gN", "<Plug>(bullets-renumber)" },
      { "nmap", "gN", "<Plug>(bullets-renumber)" },
      { "nmap", "<leader>x", "<Plug>(bullets-toggle-checkbox)" },
      { "imap", "<C-t>", "<Plug>(bullets-demote)" },
      { "nmap", ">>", "<Plug>(bullets-demote)" },
      { "vmap", ">", "<Plug>(bullets-demote)" },
      { "imap", "<C-d>", "<Plug>(bullets-promote)" },
      { "nmap", "<<", "<Plug>(bullets-promote)" },
      { "vmap", "<", "<Plug>(bullets-promote)" },
    }
  end,
  config = function()
    -- Custom <CR> that respects blink.cmp completion selection
    vim.keymap.set("i", "<CR>", function()
      local blink_ok, blink = pcall(require, "blink.cmp")
      if blink_ok and blink.get_selected_item() then
        blink.accept()
      else
        -- Use bullets.vim's newline behavior
        local key = vim.api.nvim_replace_termcodes("<Plug>(bullets-newline)", true, false, true)
        vim.api.nvim_feedkeys(key, "m", false)
      end
    end, { buffer = false, desc = "Smart CR: blink accept or bullets newline" })
  end,
}
