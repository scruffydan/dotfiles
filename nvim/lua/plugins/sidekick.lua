return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    nes = {
      -- NES (Next Edit Suggestions) is provided by copilot-language-server LSP
      -- Sidekick manages the NES feature by connecting to that LSP
      -- Disable NES if copilot-language-server not available
      enabled = require("util").copilot_available(),
      debounce = 100, -- wait 100ms after typing stops before fetching suggestions
    },
    copilot = {
      -- Disable copilot status notifications if copilot-language-server not available
      status = {
        enabled = require("util").copilot_available(),
      },
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
    -- Tab/Shift+Tab handling for smart completion and navigation
    -- Tab behavior:
    --   Insert mode: Accept copilot.vim suggestion > Apply NES > Normal Tab
    --   Normal mode: Jump to/apply NES > Normal Tab
    --   Oil buffers: Select file/directory (oil.nvim takes over)
    -- Shift+Tab behavior:
    --   Insert mode: Dedent (unindent) current line
    --   Normal mode: Open Oil file explorer (oil.lua mapping)
    --   Oil buffers: Go to parent directory (oil.nvim takes over)
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
    -- Shift+Tab for dedent in insert mode only (normal mode handled by oil.lua)
    {
      "<s-tab>",
      function()
        return vim.api.nvim_replace_termcodes("<C-d>", true, false, true)
      end,
      expr = true,
      replace_keycodes = false,
      desc = "Dedent",
      mode = "i",
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
