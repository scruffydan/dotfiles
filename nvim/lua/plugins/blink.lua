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
    
    -- Enable signature help (experimental feature, disabled by default)
    signature = {
      enabled = true,
    },
    
    -- Everything else uses blink.cmp defaults:
    -- - completion.menu.auto_show = true (dropdown shows automatically)
    -- - completion.documentation.auto_show = false (manual only via C-Space)
    -- - completion.ghost_text.enabled = false (no inline preview)
    -- - completion.accept.auto_brackets.enabled = true (auto-brackets for functions)
    -- - sources.default = { 'lsp', 'path', 'snippets', 'buffer' }
    -- - cmdline.enabled = true (command line completion)
    -- - keymap.preset = 'default' (C-Space to show, C-y to accept, C-n/C-p to navigate)
  },
}
