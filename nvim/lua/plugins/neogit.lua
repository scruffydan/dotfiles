return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "DiffView" },
    { "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Close DiffView" },
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" },
  },
  config = true,
}
