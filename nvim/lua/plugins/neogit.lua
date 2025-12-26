return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" },
  },
  config = function()
    require("neogit").setup({
      auto_close_console = false,
      graph_style = "unicode",
      commit_editor = {
        staged_diff_split_kind = "auto",
      },
      mappings = {
        popup = {
          ["d"] = false,  -- Disable built-in diff popup (use <leader>dd instead)
        },
      },
    })
  end,
}
