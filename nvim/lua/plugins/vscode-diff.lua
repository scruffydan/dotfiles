return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- Build from source on FreeBSD (no pre-built binaries available)
  build = vim.uv.os_uname().sysname == "FreeBSD" and "./build.sh" or nil,
  cmd = "CodeDiff",
  keys = {
    { "<leader>dd", "<cmd>CodeDiff<CR>", desc = "Diff explorer (git status)" },
    { "<leader>df", "<cmd>CodeDiff file HEAD<CR>", desc = "Diff file vs HEAD" },
    { "<leader>dh", "<cmd>CodeDiff file HEAD~1<CR>", desc = "Diff file vs HEAD~1" },
    {
      "<leader>db",
      function()
        -- Detect default branch (main or master)
        vim.fn.system("git rev-parse --verify main 2>/dev/null")
        local branch = vim.v.shell_error == 0 and "main" or "master"
        vim.cmd("CodeDiff " .. branch)
      end,
      desc = "Diff vs default branch",
    },
  },
  opts = {
    explorer = {
      position = "left",
      width = 40,
    },
    keymaps = {
      explorer = {
        toggle_view_mode = "e",  -- Toggle between list/tree views
      },
      diff = {
        next_hunk = { "]c", "]h" },
        prev_hunk = { "[c", "[h" },
      },
    },
  },
}
