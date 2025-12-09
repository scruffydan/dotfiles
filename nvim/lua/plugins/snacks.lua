return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
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
  },
  init = function()
    vim.api.nvim_set_hl(0, "SnacksIndent", { link = "NonText" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "NonText" })
  end,
}
