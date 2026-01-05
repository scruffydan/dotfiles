return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",  -- Optional - enables diff popup in Neogit
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" },
    { "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Close diffview" },
  },
  config = function()
    require("neogit").setup({
      auto_close_console = false,
      graph_style = "unicode",
      commit_editor = {
        staged_diff_split_kind = "auto",
      },
      integrations = {
        diffview = true,  -- Enable diffview integration (enables 'd' diff popup)
      },
    })
  end,
}
