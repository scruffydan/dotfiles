return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
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
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
          if entry.type == "directory" then return end
          local oil_dir = require("oil").get_current_dir()
          if oil_dir and vim.fn.bufnr(oil_dir .. entry.name) ~= -1 then
            return "Special"
          end
        end,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    })
  end,
}
