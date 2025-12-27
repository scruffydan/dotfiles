return {
  "github/copilot.vim",
  event = "InsertEnter",
  cmd = { "Copilot" },
  cond = function()
    return vim.fn.executable("node") == 1
  end,
  init = function()
    -- Disable default Tab mapping; Tab handling is consolidated in sidekick.lua
    vim.g.copilot_no_tab_map = true
    -- Enabled/disabled by completion mode toggle (<leader>tc) in init.lua
    vim.g.copilot_enabled = (vim.g.completion_mode or "copilot") == "copilot"
  end,
  config = function()
    -- Partial accepts - useful for taking just part of a suggestion
    vim.keymap.set("i", "<M-w>", "<Plug>(copilot-accept-word)", { desc = "Accept Copilot word" })
    vim.keymap.set("i", "<M-l>", "<Plug>(copilot-accept-line)", { desc = "Accept Copilot line" })

    -- Navigation between suggestions
    vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
    vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })

    -- Dismiss current suggestion
    vim.keymap.set("i", "<M-Esc>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })

    -- Open Copilot panel (shows up to 10 completions)
    vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { silent = true, desc = "Copilot panel" })
  end,
}
