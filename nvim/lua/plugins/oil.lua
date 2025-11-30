return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    { "<leader>e", "<CMD>Oil<CR>", desc = "Open oil" },
  },
  config = function()
    require("oil").setup({
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true,
        sort = {
          { "name", "asc" },
        },
      },
      win_options = {
        signcolumn = "yes:2",
      },
    })
  end,
}
