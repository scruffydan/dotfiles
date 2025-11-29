return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    { "<leader>b", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
  },
  config = function()
    require("nvim-tree").setup({
      hijack_netrw = true, -- Hijack netrw windows (overridden if |disable_netrw| is `true`)
      hijack_cursor = true, -- Keeps the cursor on the first letter of the filename when moving in the tree.
      view = {
        width = 30,
      },
      renderer = {
        highlight_opened_files = "name",
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      sort = {
        sorter = "name", -- You can use "name", "case_sensitive_name", "git_status", "atime", "ctime", or "mtime"
        folders_first  = false, -- Set to false to interleave files and folders based on the sorter
      },
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
      },
    })
  end,
}
