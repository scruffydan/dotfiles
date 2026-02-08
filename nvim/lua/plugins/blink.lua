-- Shared config for main and cmdline modes
local keymap = {
  preset = "enter",
  ['<Tab>'] = { 'select_next', 'fallback' },
  ['<S-Tab>'] = { 'select_prev', 'fallback' },
  ['<C-j>'] = { 'select_next', 'fallback' },
  ['<C-k>'] = { 'select_prev', 'fallback' },
}

local list_selection = {
  preselect = false, -- Don't auto-select first item
  auto_insert = false, -- Don't auto-insert on selection
}

return {
  "saghen/blink.cmp",
  version = "1.*",
  lazy = false,
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
  },

  opts = {
    -- FreeBSD compatibility: use Lua implementation on FreeBSD, Rust elsewhere
    fuzzy = {
      implementation = require("util").is_freebsd
        and "lua"
        or "prefer_rust_with_warning"
    },

    -- Enable/disable based on global flag (for completion toggle)
    enabled = function()
      return vim.g.blink_cmp_enabled ~= false
    end,

    -- Use Enter to accept completions
    -- Tab/S-Tab and C-j/C-k for navigation
    -- C-e to close menu and return to normal Tab behavior
    keymap = keymap,

    -- Enable signature help (experimental feature, disabled by default)
    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },

    -- Completion menu and documentation
    completion = {
      menu = {
        border = "rounded",
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
          components = {
            source_name = {
              highlight = "DiagnosticInfo",
            },
          },
        },
      },
      list = {
        selection = list_selection,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = {
          border = "rounded",
        },
      },
    },

    -- Sources configuration
    sources = {
      default = { "lsp", "copilot", "path", "snippets", "buffer" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          async = true,
          enabled = function()
            return require("util").copilot_available()
          end,
        },
      },
    },

    -- Command line completion
    cmdline = {
      enabled = true,
      keymap = {
        preset = "none", -- Disable default cmdline preset to allow native up/down history
        ['<Tab>'] = { 'show_and_insert', 'select_next' },
        ['<S-Tab>'] = { 'select_prev' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<Up>'] = { 'fallback' },
        ['<Down>'] = { 'fallback' },
      },
      completion = {
        list = {
          selection = list_selection,
        },
        menu = {
          auto_show = true, -- Auto-show menu in command mode
        },
      },
    },
  },
}
