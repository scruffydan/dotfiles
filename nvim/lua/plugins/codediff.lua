-- CodeDiff: Git diff viewer with side-by-side comparison
-- Provides a visual interface for reviewing git changes with split panes

-- Helper function to detect main branch (main vs master)
local function get_main_branch(prefix)
  local main = prefix and prefix .. "/main" or "main"
  local master = prefix and prefix .. "/master" or "master"
  vim.fn.system("git rev-parse --verify " .. main .. " 2>/dev/null")
  return vim.v.shell_error == 0 and main or master
end

return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- Build from source on FreeBSD (no pre-built binaries available)
  build = require("util").is_freebsd and "./build.sh" or nil,
  cmd = "CodeDiff",
  keys = {
    { "<leader>dd", "<cmd>CodeDiff<CR>", desc = "Diff all changes" },
    { "<leader>dmo", function()
      vim.cmd("CodeDiff " .. get_main_branch("origin"))
    end, desc = "Diff all vs origin/main" },
    { "<leader>dml", function()
      vim.cmd("CodeDiff " .. get_main_branch())
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
