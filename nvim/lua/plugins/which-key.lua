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
        { "<leader>dm", group = "diff vs main" },
        { "<leader>f", group = "find (workspace)" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "GitHub" },
        { "<leader>l", group = "lsp" },
        { "<leader>s", group = "search (buffer)" },
        { "<leader>S", group = "search and replace" },
        { "<leader>t", group = "toggle" },
        { "<leader>q", group = "Quickfix List" },
        { "<leader>x", group = "trouble" },
        { "]", group = "next" },
        { "[", group = "prev" },
      },
    })

    -- Set WhichKey background to match line number background
    local line_nr = vim.api.nvim_get_hl(0, { name = "LineNr" })
    vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = line_nr.bg })
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
