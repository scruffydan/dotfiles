return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = true,
    win = {
      border = "rounded",
    },
    preview = {
      type = "main",
      scratch = true,
    },
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions/References" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
  },
}
