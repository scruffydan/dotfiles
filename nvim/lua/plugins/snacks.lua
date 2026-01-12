-- Filter directories to only those that exist
local function existing_dirs(dirs)
  return vim.tbl_filter(function(dir)
    return vim.fn.isdirectory(vim.fn.expand(dir)) == 1
  end, dirs)
end

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
        hl = "SnacksIndentScope",
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
      ui_select = true, -- Replace vim.ui.select with snacks picker
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
        files = {
          hidden = true, -- Show hidden files
          ignored = true, -- Show files ignored by .gitignore
        },
        explorer = {
          hidden = true,
          ignored = true,
        },
        smart = {
          hidden = true,
          ignored = true,
          transform = "unique_file",
        },
        projects = {
          dev = existing_dirs({ "~/Code" }),
          projects = existing_dirs({
            "~/dotfiles",
            "~/Desktop",
            "~/Documents",
            "~/Downloads",
          }),
          transform = "unique_file",
        },
        spelling = {
          layout = {
            preset = "select",
          },
          win = {
            input = { border = "rounded" },
            list = { border = "rounded" },
          },
          -- Preserve spellsuggest order (sorted by likelihood)
          sort = { fields = {} },
          matcher = { sort_empty = false },
        },
        jumps = {
          -- Keep original order (most recent jumps first)
          sort = {
            fields = { "idx" },  -- Preserve the order from jumplist
          },
        },
        marks = {
          -- Custom sort function for marks picker
          -- Order: ' " a-z A-Z . < > ^ 0-9 (everything else)
          sort = function(a, b)
            -- Assign priority based on mark type
            local function mark_priority(label)
              -- Special marks for cursor position (highest priority)
              if label == "'" then return 1      -- Last jump position
              elseif label == '"' then return 2  -- Last exit position
              
              -- User-defined buffer-local marks
              elseif label:match("^[a-z]$") then return 3
              
              -- User-defined global marks
              elseif label:match("^[A-Z]$") then return 4
              
              -- Special auto-set marks
              elseif label == "." then return 5  -- Last change
              elseif label == "<" then return 6  -- Visual selection start
              elseif label == ">" then return 7  -- Visual selection end
              elseif label == "^" then return 8  -- Last insert position
              
              -- Jump history (file positions from previous Vim sessions)
              elseif label:match("^[0-9]$") then return 9  -- 0-9 exit positions
              
              -- Any other marks (lowest priority)
              else return 10
              end
            end
            
            local priority_a = mark_priority(a.label)
            local priority_b = mark_priority(b.label)
            
            -- Sort by priority first
            if priority_a ~= priority_b then
              return priority_a < priority_b
            end
            
            -- Within same priority group, sort alphabetically/numerically
            return a.label < b.label
          end,
        },
        registers = {
          -- Sort registers alphabetically by register name
          sort = { fields = { "reg" } },
          matcher = { sort_empty = true },
          main = { current = true },
          format = "register",
          preview = "preview",
          confirm = { "copy", "close" },
          -- Filter out * register (PRIMARY selection on X11, same as + on macOS)
          transform = function(item)
            if item.reg == "*" then
              return false -- Hide this register
            end
            return item -- Keep all others
          end,
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
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Comment" })
    -- Disable blink.cmp in snacks picker/input buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_*",
      callback = function()
        vim.b.blink_cmp_enabled = false
        vim.b.minipairs_disable = true
      end,
    })
  end,
  keys = {
    -- Top-level
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
    { "<leader>e", function() Snacks.picker.explorer() end, desc = "File explorer" },

    -- Find (workspace)
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (workspace)" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fh", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fm", function() Snacks.picker.man() end, desc = "Man pages" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },

    -- Search (buffer/local)
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sC", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (buffer)" },
    { "<leader>sg", function() Snacks.picker.lines() end, desc = "Grep buffer" },
    { "<leader>sG", function() Snacks.picker.grep_buffers() end, desc = "Grep open buffers" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jump list" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>sp", function() Snacks.picker.pickers() end, desc = "Pickers" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
    { "<leader>sr", function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    { "<leader>ss", function() Snacks.picker.treesitter() end, desc = "Treesitter symbols" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
    { "<leader>sw", function() Snacks.picker.spelling() end, desc = "Spell suggestions" },

    -- Git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git log (line)" },
    { "<leader>go", function() Snacks.gitbrowse() end, desc = "Open in browser (GitHub)" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git stash" },

    -- GitHub
    { "<leader>ghi", function() Snacks.picker.gh_issue() end, desc = "GitHub issues" },
    { "<leader>ghp", function() Snacks.picker.gh_pr() end, desc = "GitHub PRs" },

    -- LSP (additional keymaps in lsp.lua via LspAttach autocmd)
    { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
  },
}
