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
    
    -- Use Enter to accept completions (avoids conflict with Tab for Copilot/NES)
    keymap = {
      preset = "enter",
    },
    
    -- Enable signature help (experimental feature, disabled by default)
    signature = {
      enabled = true,
    },
    
    -- Enable documentation panel
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
      },
    },
    
    -- Everything else uses blink.cmp defaults:
    -- - completion.menu.auto_show = true (dropdown shows automatically)
    -- - completion.ghost_text.enabled = false (no inline preview)
    -- - completion.accept.auto_brackets.enabled = true (auto-brackets for functions)
    -- - sources.default = { 'lsp', 'path', 'snippets', 'buffer' }
    -- - cmdline.enabled = true (command line completion)
  },
}
