return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      preset = "helix",
      sort = { "alphanum" },
      spec = {
        { "<leader>a", group = "ai/sidekick" },
        { "<leader>d", group = "diff" },
        { "<leader>f", group = "find (workspace)" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "GitHub" },
        { "<leader>l", group = "lsp" },
        { "<leader>s", group = "search (buffer)" },
        { "<leader>t", group = "toggle" },
      },
    })
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer local keymaps",
    },
  },
}
