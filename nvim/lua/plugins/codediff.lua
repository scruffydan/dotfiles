-- CodeDiff: Git diff viewer with side-by-side comparison
-- Provides a visual interface for reviewing git changes with split panes

-- Helper function to detect main branch (main vs master)
local function get_main_branch(remote)
  local main = remote and remote .. "/main" or "main"
  local master = remote and remote .. "/master" or "master"
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
    { "<leader>d1", "<cmd>CodeDiff HEAD~1<CR>", desc = "Diff vs HEAD~1" },
    { "<leader>d2", "<cmd>CodeDiff HEAD~2<CR>", desc = "Diff vs HEAD~2" },
    { "<leader>d3", "<cmd>CodeDiff HEAD~3<CR>", desc = "Diff vs HEAD~3" },
    { "<leader>d4", "<cmd>CodeDiff HEAD~4<CR>", desc = "Diff vs HEAD~4" },
    { "<leader>d5", "<cmd>CodeDiff HEAD~5<CR>", desc = "Diff vs HEAD~5" },
  },
  opts = {
    diff = {
      disable_inlay_hints = true,
    },
    highlights = {
      -- More visible diff colors using SubMonokai palette
      line_insert = "#2d5a27",   -- Brighter green background for added lines
      line_delete = "#5a2727",   -- Brighter red background for deleted lines
      char_insert = "#3d7a37",   -- Brighter green for character-level changes
      char_delete = "#7a3737",   -- Brighter red for character-level changes
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
