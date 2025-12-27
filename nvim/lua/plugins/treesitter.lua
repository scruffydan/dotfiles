return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "mason-org/mason.nvim", -- Mason provides tree-sitter-cli
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      config = function()
        require("nvim-treesitter-textobjects").setup({
          select = {
            lookahead = true, -- Jump forward to matching text object
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V",  -- linewise
              ["@class.outer"] = "V",     -- linewise
              ["@loop.outer"] = "V",      -- linewise
              ["@conditional.outer"] = "V", -- linewise
            },
          },
          move = {
            set_jumps = true, -- Set jumps in the jumplist
          },
        })

        local ts_select = require("nvim-treesitter-textobjects.select")
        local move = require("nvim-treesitter-textobjects.move")
        local swap = require("nvim-treesitter-textobjects.swap")

        -- Text object selection keymaps
        local select_keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
          ["a/"] = "@comment.outer",
          ["i/"] = "@comment.inner",
        }
        for key, query in pairs(select_keymaps) do
          vim.keymap.set({ "x", "o" }, key, function()
            ts_select.select_textobject(query, "textobjects")
          end, { desc = "Select " .. query })
        end

        -- Movement keymaps
        local move_keymaps = {
          ["]f"] = { move.goto_next_start, "@function.outer", "Next function start" },
          ["]F"] = { move.goto_next_end, "@function.outer", "Next function end" },
          ["[f"] = { move.goto_previous_start, "@function.outer", "Previous function start" },
          ["[F"] = { move.goto_previous_end, "@function.outer", "Previous function end" },
          ["]c"] = { move.goto_next_start, "@class.outer", "Next class start" },
          ["]C"] = { move.goto_next_end, "@class.outer", "Next class end" },
          ["[c"] = { move.goto_previous_start, "@class.outer", "Previous class start" },
          ["[C"] = { move.goto_previous_end, "@class.outer", "Previous class end" },
          ["]a"] = { move.goto_next_start, "@parameter.inner", "Next parameter" },
          ["[a"] = { move.goto_previous_start, "@parameter.inner", "Previous parameter" },
        }
        for key, mapping in pairs(move_keymaps) do
          local fn, query, desc = mapping[1], mapping[2], mapping[3]
          vim.keymap.set({ "n", "x", "o" }, key, function()
            fn(query, "textobjects")
          end, { desc = desc })
        end

        -- Swap keymaps
        vim.keymap.set("n", "<leader>sn", function()
          swap.swap_next("@parameter.inner")
        end, { desc = "Swap parameter with next" })
        vim.keymap.set("n", "<leader>sp", function()
          swap.swap_previous("@parameter.inner")
        end, { desc = "Swap parameter with previous" })
      end,
    },
  },
  cond = function()
    -- Requires tree-sitter-cli and a C compiler
    local has_tree_sitter = vim.fn.executable("tree-sitter") == 1
    local has_cc = vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1
    if not has_tree_sitter or not has_cc then
      vim.defer_fn(function()
        vim.notify("nvim-treesitter: missing requirements\n(tree-sitter-cli and/or C compiler)", vim.log.levels.WARN)
      end, 100)
      return false
    end
    return true
  end,
  config = function()
    local ts = require("nvim-treesitter")

    -- Setup treesitter (uses default install_dir)
    ts.setup()

    -- Pre-install common parsers
    ts.install({
      "bash",
      "css",
      "csv",
      "diff",
      "dockerfile",
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
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "ssh_config",
      "terraform",
      "tmux",
      "toml",
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

        -- Install parser if not already installed
        if not pcall(vim.treesitter.language.inspect, lang) then
          ts.install(lang)
        end

        -- Enable highlighting and indentation
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
