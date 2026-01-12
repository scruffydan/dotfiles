-- Copilot inline completion plugin (copilot.vim)
--
-- This provides inline code suggestions as you type in insert mode.
-- Note: This is separate from NES (Next Edit Suggestions), which requires
-- the copilot-language-server LSP configured in lsp/copilot.lua.
--
-- Install: Requires Node.js and GitHub Copilot subscription
-- Setup: Run :Copilot setup on first use

return {
  "github/copilot.vim",
  event = "InsertEnter",
  cmd = { "Copilot" },
  cond = function()
    return vim.fn.executable("node") == 1
  end,
  init = function()
    -- Disable default Tab mapping
    -- Tab handling is consolidated in sidekick.lua for smart behavior:
    --   Insert mode: Accept copilot suggestion > Apply NES > Normal Tab
    --   Normal mode: Apply NES > Normal Tab
    vim.g.copilot_no_tab_map = true
    -- Ghost text off by default, toggle with <leader>tgc
    vim.g.copilot_enabled = false
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
    vim.keymap.set("n", "<leader>ghP", ":Copilot panel<CR>", { silent = true, desc = "Copilot panel" })

    -- Toggle Copilot ghost text (inline suggestions)
    vim.keymap.set("n", "<leader>tgc", function()
      if vim.g.copilot_enabled == false then
        vim.cmd("Copilot enable")
        vim.g.copilot_enabled = true
        vim.notify("Copilot ghost text enabled", vim.log.levels.INFO)
      else
        vim.cmd("Copilot disable")
        vim.g.copilot_enabled = false
        vim.notify("Copilot ghost text disabled", vim.log.levels.INFO)
      end
    end, { desc = "Toggle Copilot ghost text" })
  end,
}
