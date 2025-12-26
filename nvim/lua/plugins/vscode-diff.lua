return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>dd", "<cmd>CodeDiff<CR>", desc = "Diff explorer (git status)" },
    { "<leader>df", "<cmd>CodeDiff file HEAD<CR>", desc = "Diff file vs HEAD" },
  },
  opts = {},
}
