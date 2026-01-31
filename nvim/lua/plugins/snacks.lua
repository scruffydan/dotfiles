-- Filter directories to only those that exist
local function existing_dirs(dirs)
  return vim.tbl_filter(function(dir)
    return vim.fn.isdirectory(vim.fn.expand(dir)) == 1
  end, dirs)
end

-- Get all subdirectories of a given path
local function get_subdirs(path)
  local expanded = vim.fn.expand(path)
  local dirs = {}
  for name, type in vim.fs.dir(expanded) do
    if type == "directory" then
      table.insert(dirs, expanded .. "/" .. name)
    end
  end
  return dirs
end

local indent_exclude = {
  help = true,
  dashboard = true,
  lazy = true,
  mason = true,
  oil = true,
}

-- Mark priority for picker sorting: lower = appears first
-- 1-2: cursor marks (' "), 3: local (a-z), 4: global (A-Z),
-- 5-8: special (. < > ^), 9: numbered (0-9), 10: other
local mark_priorities = {
  ["'"] = 1, ['"'] = 2,
  ["."] = 5, ["<"] = 6, [">"] = 7, ["^"] = 8,
}

local function get_mark_priority(label)
  return mark_priorities[label]
    or (label:match("^[a-z]$") and 3)
    or (label:match("^[A-Z]$") and 4)
    or (label:match("^[0-9]$") and 9)
    or 10
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = {
      enabled = true,
      timeout = 3000, -- ms
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
        return vim.g.snacks_indent ~= false
          and vim.b[buf].snacks_indent ~= false
          and vim.bo[buf].buftype == ""
          and not indent_exclude[vim.bo[buf].filetype]
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

        recent = {
          sort = { fields = { "idx" } }, -- Sort by recency
          matcher = { frecency = false, sort_empty = false }, -- Disable frecency
        },

        projects = {
          -- Use finder to defer filesystem I/O until picker opens
          finder = function()
            local dirs = vim.list_extend(
              get_subdirs("~/Code"),
              existing_dirs({
                "~/dotfiles",
                "~/Desktop",
                "~/Documents",
                "~/Downloads",
              })
            )
            return vim.tbl_map(function(dir)
              return { file = dir, text = dir }
            end, dirs)
          end,
          -- Custom format to show ~/path instead of ⋮reponame
          format = function(item, picker)
            local path = item.file or item.text
            local name = vim.fn.fnamemodify(path, ":t")
            local dir = vim.fn.fnamemodify(path, ":h")
            local home = vim.fn.expand("~")
            if dir:find(home, 1, true) == 1 then
              dir = "~" .. dir:sub(#home + 1)
            end
            local icon = picker.opts.icons.files.dir or ""
            return {
              { icon, "Directory" },
              { name .. " ", "SnacksPickerFile" },
              { dir, "SnacksPickerDir" },
            }
          end,
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
          -- Custom sort function: Group marks by type, then sort alphabetically
          sort = function(mark_a, mark_b)
            -- 1. Sort by Priority (Type)
            -- Lower score = higher priority (e.g., cursor marks appear first)
            local priority_a = get_mark_priority(mark_a.label)
            local priority_b = get_mark_priority(mark_b.label)

            if priority_a ~= priority_b then
              return priority_a < priority_b
            end

            -- 2. Tie-breaker: Sort Alphabetically
            -- If types are the same (e.g. both are global marks 'A' and 'B')
            return mark_a.label < mark_b.label
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

        buffers = {
          sort_lastused = true, -- Sort by recency
          matcher = { frecency = false, sort_empty = false }, -- Disable frecency
          current = false, -- Hide current buffer from list
        },

        -- Set buffer filetype from available filetypes
        filetype = {
          -- Deferred to avoid vim.fn.getcompletion() at startup
          finder = function()
            return vim.tbl_map(function(ft)
              return { text = ft }
            end, vim.fn.getcompletion("", "filetype"))
          end,
          format = "text",
          preview = "none",
          layout = { preset = "select" },
          confirm = function(picker, item)
            picker:close()
            if not item then return end
            vim.bo.filetype = item.text
            vim.notify("Filetype set to: " .. item.text, vim.log.levels.INFO)
          end,
        },

        -- Detach LSP clients from current buffer
        lsp_clients = {
          finder = function()
            return vim.tbl_map(function(client)
              return { text = client.name, client_id = client.id }
            end, vim.lsp.get_clients({ bufnr = 0 }))
          end,
          format = "text",
          preview = "none",
          layout = { preset = "select" },
          confirm = function(picker, item)
            picker:close()
            if not item then return end
            vim.lsp.buf_detach_client(0, item.client_id)
            vim.notify("Detached LSP: " .. item.text, vim.log.levels.INFO)
          end,
        },
      },
    },
    bigfile = {
      size = 1024 * 1024, -- 1MB
    },
    input = {}, -- Enable with defaults
    image = {}, -- Enable with defaults
    statuscolumn = {
      left = { "sign" }, -- Show diagnostic/other signs
      right = { "fold", "git" }, -- Git signs on right
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 150 },
        easing = "outCubic",
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
    { "<leader>fP", function() Snacks.picker.pickers() end, desc = "Pickers" },
    { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume last picker" },
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
    { "<leader>sf", function() Snacks.picker.pick("filetype") end, desc = "Set filetype" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
    { "<leader>sr", function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>ss", function() Snacks.picker.treesitter() end, desc = "Treesitter symbols" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
    { "<leader>sw", function() Snacks.picker.spelling() end, desc = "Spell suggestions" },

    -- Git
    { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "Git branches" },
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

    -- LSP
    { "<leader>lc", function() Snacks.picker.pick("lsp_clients") end, desc = "Detach LSP client" },
    { "<leader>lf", function() Snacks.picker.lsp_definitions() end, desc = "Find definitions" },
    { "<leader>li", function() Snacks.picker.lsp_incoming_calls() end, desc = "Incoming calls" },
    { "<leader>lI", function() Snacks.picker.lsp_implementations() end, desc = "Implementations" },
    { "<leader>lo", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Outgoing calls" },
    { "<leader>lr", function() Snacks.picker.lsp_references() end, desc = "References" },
    { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Type definitions" },
  },
}
