return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },
    gitbrowse = {
      notify = true,
    },
    indent = {
      enabled = true,
      char = "│",
      scope = {
        enabled = true,
        char = "│",
        hl = "NonText",
      },
      filter = function(buf)
        local exclude = { "help", "dashboard", "lazy", "mason", "oil" }
        local ft = vim.bo[buf].filetype
        return vim.g.snacks_indent ~= false
          and vim.b[buf].snacks_indent ~= false
          and vim.bo[buf].buftype == ""
          and not vim.tbl_contains(exclude, ft)
      end,
    },
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
    },
  },
  init = function()
    vim.api.nvim_set_hl(0, "SnacksIndent", { link = "NonText" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "NonText" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Comment" })
  end,
  keys = {
    { "<leader>fn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>go", function() Snacks.gitbrowse() end, desc = "Open in browser (GitHub)" },
    -- Picker keybindings (replacing fzf-lua)
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fr", function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search buffer" },
    { "<leader>fs", function() Snacks.picker.spelling() end, desc = "Spell suggestions" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
  },
}
