return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  event = "VeryLazy",
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
        create = "split",
      },
    },
  },
  keys = {
    -- NES (Next Edit Suggestions) keybinding
    {
      "<tab>",
      function()
        -- Jump to next edit suggestion, or apply if at the edit location
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"  -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
      mode = { "n" },
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
      desc = "Sidekick Select CLI",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Sidekick Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Sidekick Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Sidekick Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Direct access to specific CLI tools
    {
      "<leader>ao",
      function() require("sidekick.cli").show({ name = "opencode", focus = true }) end,
      desc = "Sidekick Open OpenCode",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").show({ name = "claude", focus = true }) end,
      desc = "Sidekick Open Claude",
    },
    -- Context-aware prompts (similar to opencode.nvim)
    {
      "<leader>ae",
      function() require("sidekick.cli").send({ msg = "Explain {this}" }) end,
      mode = { "n", "x" },
      desc = "Sidekick Explain",
    },
    {
      "<leader>ar",
      function() require("sidekick.cli").send({ msg = "Can you review {file} for any issues or improvements?" }) end,
      mode = { "n", "x" },
      desc = "Sidekick Review",
    },
    {
      "<leader>aF",
      function() require("sidekick.cli").send({ msg = "Can you fix {this}?" }) end,
      mode = { "n", "x" },
      desc = "Sidekick Fix",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").send({ msg = "Can you help me fix the diagnostics in {file}?\n{diagnostics}" }) end,
      desc = "Sidekick Fix Diagnostics (buffer)",
    },
    {
      "<leader>aD",
      function() require("sidekick.cli").send({ msg = "Can you help me fix these diagnostics?\n{diagnostics_all}" }) end,
      desc = "Sidekick Fix Diagnostics (all)",
    },
    {
      "<leader>ai",
      function() require("sidekick.cli").send({ msg = "Add documentation to {this}" }) end,
      mode = { "n", "x" },
      desc = "Sidekick Document",
    },
    {
      "<leader>az",
      function() require("sidekick.cli").send({ msg = "How can {this} be optimized?" }) end,
      mode = { "n", "x" },
      desc = "Sidekick Optimize",
    },
    {
      "<leader>aT",
      function() require("sidekick.cli").send({ msg = "Can you write tests for {this}?" }) end,
      mode = { "n", "x" },
      desc = "Sidekick Write Tests",
    },
  },
}
