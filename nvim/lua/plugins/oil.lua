return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    { "<leader>o", "<CMD>Oil<CR>", desc = "Open oil" },
    { "<S-Tab>", "<CMD>Oil<CR>", mode = "n", desc = "Open oil" }, -- pairs with <Tab> in oil keymaps
  },
  config = function()
    require("oil").setup({
      watch_for_changes = true,
      columns = {
        "icon",
      },
      keymaps = {
        ["<leader>h"] = "actions.toggle_hidden",
        ["<Tab>"] = "actions.select", -- <S-Tab> global keymap in keys section
        ["<S-Tab>"] = "actions.parent",
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
