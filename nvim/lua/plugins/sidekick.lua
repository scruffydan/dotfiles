return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
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
