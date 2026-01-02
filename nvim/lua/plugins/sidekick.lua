-- Check if Copilot is available and authenticated
local function copilot_nes_available()
  if vim.fn.executable("copilot-language-server") ~= 1 then
    return false
  end
  local copilot_config_dir = vim.fn.expand("~/.config/github-copilot")
  return vim.fn.isdirectory(copilot_config_dir) == 1
end

return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    nes = {
      -- Disable NES if copilot-language-server not available or not authenticated
      enabled = copilot_nes_available(),
      debounce = 100, -- wait 100ms after typing stops before fetching suggestions
    },
    cli = {
      watch = true, -- auto-reload files modified by AI CLI tools
      mux = {
        backend = "tmux",
        enabled = true,
        create = "split",
      },
    },
  },
  keys = {
    -- Tab handling for both insert and normal mode
    -- Insert: Accept copilot.vim suggestion > Apply NES > Normal Tab
    -- Normal: Jump to/apply NES > Normal Tab
    {
      "<tab>",
      function()
        -- In insert mode, first check for copilot.vim inline suggestion
        if vim.fn.mode() == "i" then
          if vim.fn.exists("*copilot#GetDisplayedSuggestion") == 1
            and vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
            return vim.fn["copilot#Accept"]()
          end
        end
        -- Then check sidekick NES (works in both insert and normal mode)
        if require("sidekick").nes_jump_or_apply() then
          return ""
        end
        -- Fall back to normal tab
        return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
      end,
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot / Apply NES / Tab",
      mode = { "i", "n" },
    },
    {
      "<leader>tN",
      function()
        local nes = require("sidekick.nes")
        nes.toggle()
        vim.notify("NES " .. (nes.enabled and "enabled" or "disabled"), vim.log.levels.INFO)
      end,
      desc = "Toggle NES (Next Edit Suggestions)",
    },
    -- Toggle sidekick CLI
    {
      "<c-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    -- Leader keymaps using <leader>a prefix
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      desc = "Select CLI",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send @This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Select Prompt Sidekick",
    },
    -- Direct access to specific CLI tools
    {
      "<leader>ao",
      function() require("sidekick.cli").show({ name = "opencode", focus = true }) end,
      desc = "Open OpenCode",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").show({ name = "claude", focus = true }) end,
      desc = "Open Claude",
    },
    -- Context-aware prompts (similar to opencode.nvim)
    {
      "<leader>ae",
      function() require("sidekick.cli").send({ msg = "Explain {this}" }) end,
      mode = { "n", "x" },
      desc = "AI Explain",
    },
    {
      "<leader>ar",
      function() require("sidekick.cli").send({ msg = "Can you review {file} for any issues or improvements?" }) end,
      mode = { "n", "x" },
      desc = "AI Review",
    },
    {
      "<leader>ag",
      function() require("sidekick.cli").send({ msg = "{changes}" }) end,
      desc = "Review Changes (git diff)",
    },
    {
      "<leader>aF",
      function() require("sidekick.cli").send({ msg = "Can you fix {this}?" }) end,
      mode = { "n", "x" },
      desc = "AI Fix",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").send({ msg = "Can you help me fix the diagnostics in {file}?\n{diagnostics}" }) end,
      desc = "Fix Diagnostics (buffer)",
    },
    {
      "<leader>aD",
      function() require("sidekick.cli").send({ msg = "Can you help me fix these diagnostics?\n{diagnostics_all}" }) end,
      desc = "Fix Diagnostics (all)",
    },
    {
      "<leader>ai",
      function() require("sidekick.cli").send({ msg = "Add documentation to {this}" }) end,
      mode = { "n", "x" },
      desc = "Add Documentation",
    },
    {
      "<leader>az",
      function() require("sidekick.cli").send({ msg = "How can {this} be optimized?" }) end,
      mode = { "n", "x" },
      desc = "AI Optimize",
    },
    {
      "<leader>aT",
      function() require("sidekick.cli").send({ msg = "Can you write tests for {this}?" }) end,
      mode = { "n", "x" },
      desc = "AI Write Tests",
    },
  },
}
