return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "-", "<CMD>Oil --float<CR>", desc = "Open parent directory" },
    { "<leader>e", "<CMD>Oil --float<CR>", desc = "Open oil" },
  },
  config = function()
    require("oil").setup({
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      view_options = {
        show_hidden = true,
        sort = {
          { "name", "asc" },
        },
      },
      float = {
        padding = 2,
        max_width = 0.8,
        max_height = 0.8,
        border = "rounded",
      },
      win_options = {
        signcolumn = "yes:2",
      },
    })
  end,
}
