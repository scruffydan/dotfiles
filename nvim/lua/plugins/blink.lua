return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "LspAttach" },
  dependencies = { "rafamadriz/friendly-snippets" },
  
  opts = {
    -- FreeBSD compatibility: use Lua implementation on FreeBSD, Rust elsewhere
    fuzzy = { 
      implementation = vim.loop.os_uname().sysname == "FreeBSD" 
        and "lua" 
        or "prefer_rust_with_warning"
    },
    
    -- Enable/disable based on global flag (for completion toggle)
    enabled = function()
      return vim.g.blink_cmp_enabled ~= false
    end,
    
    -- Use Enter to accept completions
    -- Use C-j/C-k for navigation (C-j down, C-k up)
    keymap = {
      preset = "enter",
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    
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
      },
      list = {
        selection = {
          preselect = false, -- Don't auto-select first item
          auto_insert = false, -- Don't auto-insert on selection
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = {
          border = "rounded",
        },
      },
    },
    
    -- Command line completion
    cmdline = {
      enabled = true,
      keymap = {
        preset = "enter",
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
      },
      completion = {
        list = {
          selection = {
            preselect = false, -- Don't auto-select first item
            auto_insert = false, -- Don't auto-insert on selection
          },
        },
        menu = {
          auto_show = true, -- Auto-show menu in command mode
        },
      },
    },
    
    -- Everything else uses blink.cmp defaults:
    -- - completion.menu.auto_show = true (dropdown shows automatically)
    -- - completion.ghost_text.enabled = false (no inline preview)
    -- - completion.accept.auto_brackets.enabled = true (auto-brackets for functions)
    -- - sources.default = { 'lsp', 'path', 'snippets', 'buffer' }
  },
}
