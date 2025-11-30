return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    { "<leader>o", "<CMD>Oil<CR>", desc = "Open oil" },
  },
  config = function()
    require("oil").setup()
  end,
}
