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
      matcher = {
        frecency = true, -- Boost recently/frequently accessed files
        sort_empty = true, -- Sort by frecency even before typing
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        spelling = {
          layout = {
            preset = "select",
          },
          win = {
            input = { border = "rounded" },
            list = { border = "rounded" },
          },
        },
      },
    },
    bigfile = {
      size = 1024 * 1024, -- 1MB
    },
    input = {},
    image = {},
    statuscolumn = {
      left = { "sign" }, -- Show diagnostic/other signs
      right = { "fold", "git" }, -- Git signs on right
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 150 },
        easing = "linear",
      },
    },
    scope = { enabled = true },
    words = { enabled = true },
  },
  init = function()
    vim.api.nvim_set_hl(0, "SnacksIndent", { link = "NonText" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "NonText" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Comment" })
    -- Disable mini.completion in snacks picker/input buffers
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "InsertEnter" }, {
      pattern = "*",
      callback = function()
        local ft = vim.bo.filetype
        local bt = vim.bo.buftype
        if ft:match("^snacks") or bt == "prompt" then
          vim.b.minicompletion_disable = true
          vim.b.minipairs_disable = true
        end
      end,
    })
  end,
  keys = {
    { "<leader>fn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>go", function() Snacks.gitbrowse() end, desc = "Open in browser (GitHub)" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fr", function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>lD", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (picker)" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search buffer" },
    { "<leader>fs", function() Snacks.picker.spelling() end, desc = "Spell suggestions" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "Git branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git log (line)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
    { "<leader>gD", function() Snacks.picker.git_diff() end, desc = "Git diff hunks" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git stash" },
    { "<leader>ghi", function() Snacks.picker.gh_issue() end, desc = "GitHub issues" },
    { "<leader>ghp", function() Snacks.picker.gh_pr() end, desc = "GitHub PRs" },
    -- LSP
    { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    -- Undo
    { "<leader>u", function() Snacks.picker.undo() end, desc = "Undo history" },
  },
}
