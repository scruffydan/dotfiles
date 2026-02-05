-- Treesitter configuration for syntax highlighting, indentation, and text objects
-- Dependencies:
--   - nvim-treesitter-context: Shows code context (function/class) at top of window
--   - nvim-treesitter-textobjects: Adds text object selection and movement keymaps
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "mason-org/mason.nvim", -- Mason provides tree-sitter-cli
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 3,
        min_window_height = 20,
        multiline_threshold = 1,
        separator = "-",
      },
      keys = {
        {
          "<leader>tC",
          function()
            local tsc = require("treesitter-context")
            tsc.toggle()
            local enabled = require("treesitter-context.config").enabled
            vim.notify("Treesitter context: " .. (enabled and "on" or "off"), vim.log.levels.INFO)
          end,
          desc = "Toggle treesitter context",
        },
      },
      config = function(_, opts)
        require("treesitter-context").setup(opts)
        -- Use same background as SignColumn
        vim.api.nvim_set_hl(0, "TreesitterContext", { link = "SignColumn" })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      config = function()
        require("nvim-treesitter-textobjects").setup({
          select = {
            lookahead = true, -- Jump forward to matching text object
          },
          move = {
            set_jumps = true, -- Set jumps in the jumplist
          },
        })

        local ts_select = require("nvim-treesitter-textobjects.select")
        local move = require("nvim-treesitter-textobjects.move")

        -- Text object selection keymaps
        -- Pattern: 'a' = around (outer), 'i' = inside (inner)
        -- Note: 'in' and 'an' are reserved for built-in incremental selection (expand/shrink)
        local select_keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ap"] = "@parameter.outer",
          ["ip"] = "@parameter.inner",
          ["aa"] = "@attribute.outer",
          ["ia"] = "@attribute.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
          ["a/"] = "@comment.outer",
          ["i/"] = "@comment.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["a="] = "@assignment.outer",
          ["i="] = "@assignment.inner",
          ["ar"] = "@return.outer",
          ["ir"] = "@return.inner",
        }
        for key, query in pairs(select_keymaps) do
          vim.keymap.set({ "x", "o" }, key, function()
            ts_select.select_textobject(query, "textobjects")
          end, { desc = "Select " .. query })
        end

        -- Movement keymaps
        -- Pattern: ']' = next, '[' = previous, lowercase = start, uppercase = end
        local move_keymaps = {
          ["]f"] = { move.goto_next_start, "@function.outer", "Next function start" },
          ["]F"] = { move.goto_next_end, "@function.outer", "Next function end" },
          ["[f"] = { move.goto_previous_start, "@function.outer", "Previous function start" },
          ["[F"] = { move.goto_previous_end, "@function.outer", "Previous function end" },
          ["]c"] = { move.goto_next_start, "@class.outer", "Next class start" },
          ["]C"] = { move.goto_next_end, "@class.outer", "Next class end" },
          ["[c"] = { move.goto_previous_start, "@class.outer", "Previous class start" },
          ["[C"] = { move.goto_previous_end, "@class.outer", "Previous class end" },
          ["]p"] = { move.goto_next_start, "@parameter.inner", "Next parameter" },
          ["[p"] = { move.goto_previous_start, "@parameter.inner", "Previous parameter" },
          ["]a"] = { move.goto_next_start, "@attribute.outer", "Next attribute" },
          ["[a"] = { move.goto_previous_start, "@attribute.outer", "Previous attribute" },
          ["]b"] = { move.goto_next_start, "@block.outer", "Next block" },
          ["[b"] = { move.goto_previous_start, "@block.outer", "Previous block" },
          ["]B"] = { move.goto_next_end, "@block.outer", "Next block end" },
          ["[B"] = { move.goto_previous_end, "@block.outer", "Previous block end" },
          ["]l"] = { move.goto_next_start, "@loop.outer", "Next loop" },
          ["[l"] = { move.goto_previous_start, "@loop.outer", "Previous loop" },
          ["]L"] = { move.goto_next_end, "@loop.outer", "Next loop end" },
          ["[L"] = { move.goto_previous_end, "@loop.outer", "Previous loop end" },
          ["]i"] = { move.goto_next_start, "@conditional.outer", "Next conditional" },
          ["[i"] = { move.goto_previous_start, "@conditional.outer", "Previous conditional" },
          ["]I"] = { move.goto_next_end, "@conditional.outer", "Next conditional end" },
          ["[I"] = { move.goto_previous_end, "@conditional.outer", "Previous conditional end" },
          ["]/"] = { move.goto_next_start, "@comment.outer", "Next comment" },
          ["[/"] = { move.goto_previous_start, "@comment.outer", "Previous comment" },
          ["]?"] = { move.goto_next_end, "@comment.outer", "Next comment end" },
          ["[?"] = { move.goto_previous_end, "@comment.outer", "Previous comment end" },
          ["]="] = { move.goto_next_start, "@assignment.outer", "Next assignment" },
          ["[="] = { move.goto_previous_start, "@assignment.outer", "Previous assignment" },
          ["]n"] = { move.goto_next_start, "@number.inner", "Next number" },
          ["[n"] = { move.goto_previous_start, "@number.inner", "Previous number" },
          ["]r"] = { move.goto_next_start, "@return.outer", "Next return" },
          ["[r"] = { move.goto_previous_start, "@return.outer", "Previous return" },
        }
        for key, mapping in pairs(move_keymaps) do
          local fn, query, desc = mapping[1], mapping[2], mapping[3]
          vim.keymap.set({ "n", "x", "o" }, key, function()
            fn(query, "textobjects")
          end, { desc = desc })
        end
      end,
    },
  },
  cond = function()
    local function has_executable(cmd)
      return vim.fn.executable(cmd) == 1
    end

    -- Requires tree-sitter-cli and a C compiler
    local has_tree_sitter = has_executable("tree-sitter")
    local has_cc = has_executable("cc") or has_executable("gcc") or has_executable("clang")

    if has_tree_sitter and has_cc then
      return true
    end

    vim.defer_fn(function()
      vim.notify("nvim-treesitter: missing requirements\n(tree-sitter-cli and/or C compiler)", vim.log.levels.WARN)
    end, 100)
    return false
  end,
  config = function()
    local treesitter = require("nvim-treesitter")

    -- Setup treesitter (uses default install_dir)
    treesitter.setup()

    -- Pre-install common parsers
    treesitter.install({
      "bash",
      "c",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "editorconfig",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gotmpl",
      "gpg",
      "hcl",
      "helm",
      "html",
      "http",
      "ini",
      "javascript",
      "jinja",
      "jinja_inline",
      "jq",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "rust",
      "ssh_config",
      "terraform",
      "tmux",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "zsh",
    })

    -- Install other parsers on-demand and enable highlighting/indentation
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local ft = vim.bo.filetype
        if ft == "" then return end

        local lang = vim.treesitter.language.get_lang(ft) or ft

        -- Install parser if not already installed and supported
        if not pcall(vim.treesitter.language.inspect, lang) then
          local parsers = require("nvim-treesitter.parsers")
          if parsers[lang] then
            treesitter.install(lang)
          end
        end

        -- Enable highlighting and indentation
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
