return {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    -- Disable default Tab mapping, we'll use our own
    vim.g.copilot_no_tab_map = true
    -- Enable by default (toggled with <leader>ai)
    vim.g.copilot_enabled = true
  end,
  config = function()
    -- Accept completion with Tab
    vim.keymap.set("i", "<Tab>", function()
      if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
        return vim.fn["copilot#Accept"]()
      end
      -- Check sidekick NES
      if require("sidekick").nes_jump_or_apply() then
        return ""
      end
      return "<Tab>"
    end, { expr = true, replace_keycodes = false, desc = "Accept Copilot or Tab" })
  end,
}
