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
    -- Tab for NES (Next Edit Suggestions)
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
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
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      desc = "Sidekick Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Sidekick Detach CLI Session",
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
  },
}
