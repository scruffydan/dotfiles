return {
  "github/copilot.vim",
  event = "InsertEnter",
  cmd = { "Copilot" },
  init = function()
    -- Disable default Tab mapping, we'll use our own
    vim.g.copilot_no_tab_map = true
    -- Enabled/disabled by completion mode toggle (<leader>tc) in init.lua
    vim.g.copilot_enabled = (vim.g.completion_mode or "copilot") == "copilot"
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
      -- Use vim.api to get the actual tab keycode
      return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    end, { expr = true, replace_keycodes = false, desc = "Accept Copilot or Tab" })
  end,
}
