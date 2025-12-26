return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "DiffView" },
    { "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Close DiffView" },
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" },
  },
  config = function()
    require("neogit").setup({
      auto_close_console = false,
      graph_style = "unicode",
      commit_editor = {
        staged_diff_split_kind = "auto",
      },
    })
  end,
}
