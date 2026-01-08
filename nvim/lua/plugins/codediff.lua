return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>dd", "<cmd>CodeDiff<CR>", desc = "Diff all changes" },
    { "<leader>dmo", function()
      vim.fn.system("git rev-parse --verify origin/main 2>/dev/null")
      local branch = vim.v.shell_error == 0 and "origin/main" or "origin/master"
      vim.cmd("CodeDiff " .. branch)
    end, desc = "Diff all vs origin/main" },
    { "<leader>dml", function()
      vim.fn.system("git rev-parse --verify main 2>/dev/null")
      local branch = vim.v.shell_error == 0 and "main" or "master"
      vim.cmd("CodeDiff " .. branch)
    end, desc = "Diff all vs local main" },
  },
  opts = {
    diff = {
      disable_inlay_hints = true,
    },
    keymaps = {
      view = {
        quit = "q",
        toggle_explorer = "<leader>b",
        next_hunk = "]h",
        prev_hunk = "[h",
        next_file = "]f",
        prev_file = "[f",
        diff_get = "do",
        diff_put = "dp",
      },
    },
  },
}
