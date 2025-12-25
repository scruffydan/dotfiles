# Neovim Plugin Configuration Comparison Report

Generated: December 25, 2025

This report compares your nvim plugin configurations against their official README recommendations.

---

## Table of Contents

1. [csvview.nvim](#1-csvviewnvim)
2. [gitsigns.nvim](#2-gitsignsnvim)
3. [nvim-lspconfig](#3-nvim-lspconfig)
4. [lualine.nvim](#4-lualinenvim)
5. [mason.nvim](#5-masonnvim)
6. [mini.nvim](#6-mininvim)
7. [neogit](#7-neogit)
8. [oil.nvim](#8-oilnvim)
9. [sidekick.nvim](#9-sidekicknvim)
10. [snacks.nvim](#10-snacksnvim)
11. [nvim-treesitter](#11-nvim-treesitter)
12. [vim-tmux-navigator](#12-vim-tmux-navigator)
13. [which-key.nvim](#13-which-keynvim)
14. [mason-lspconfig.nvim](#14-mason-lspconfignvim)
15. [Summary](#summary)

---

## 1. csvview.nvim

**Status:** ✅ Good

Your setup aligns well with recommended patterns.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Lazy loading | `ft = { "csv", "tsv" }` | Recommended: `cmd = { "CsvViewEnable", ... }` |
| Keymaps | Custom text objects + navigation | Matches recommended patterns |
| Display mode | `border` | Good choice (alternative to `highlight`) |

### Suggestions

- Add `parser = { comments = { "#", "//" } }` to handle comment lines in CSVs

---

## 2. gitsigns.nvim

**Status:** ⚠️ Minor Gaps

Your setup is mostly complete but missing some recommended features.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Signs | Custom characters (`▎`, `▁`, etc.) | Good customization |
| `signs_staged` | Missing | README recommends `signs_staged_enable = true` |
| Navigation | Uses `next_hunk()` | README recommends `nav_hunk('next')` (newer API) |
| Text object | Missing | README recommends `map({'o', 'x'}, 'ih', gitsigns.select_hunk)` |

### Suggested Additions

```lua
-- Add to your gitsigns config:
signs_staged_enable = true,

-- Add hunk text object in on_attach:
map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

-- Update navigation to newer API:
map('n', ']c', function() gitsigns.nav_hunk('next') end)
map('n', '[c', function() gitsigns.nav_hunk('prev') end)
```

---

## 3. nvim-lspconfig

**Status:** ✅ Modern Setup

Your setup uses the new Neovim 0.11+ `vim.lsp.config()` and `vim.lsp.enable()` APIs correctly!

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| API | `vim.lsp.config()` + `vim.lsp.enable()` | Correct modern approach |
| Diagnostics | Custom sign text (`E`, `W`, `H`, `I`) | Good customization |
| Keymaps | Comprehensive LspAttach autocmd | Matches recommendations |

### Notes

- The README states `require('lspconfig')` is **deprecated** in favor of `vim.lsp.config()` - you're doing it right!
- Your configuration properly uses the native LSP APIs introduced in Neovim 0.11

---

## 4. lualine.nvim

**Status:** ✅ Good

Your setup follows recommended patterns with nice customizations.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Theme | `submonokai` | Custom theme is fine |
| `globalstatus` | `true` | Modern approach |
| Sections | Customized with recording indicator, searchcount | Creative additions |
| `showmode` | Disabled via `vim.opt` | Correct (lualine handles it) |

### Notes

- You disable `cmdheight = 0` which is fine but can cause message display issues
- The recording macro indicator is a nice touch

---

## 5. mason.nvim

**Status:** ✅ Good

Your setup is solid with useful additions.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Priority | `priority = 100` | Good (ensures early loading) |
| PATH prepend | Custom logic to add Mason bin | Good approach |
| Auto-install | `tree-sitter-cli` | Good integration with treesitter |

---

## 6. mini.nvim

**Status:** ⚠️ Limited Usage

Your setup only uses 2 of 40+ available modules.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Modules used | `mini.pairs`, `mini.completion` | Only 2 modules |
| Completion delay | 1000ms | Very long - default is 100ms |
| Event loading | `InsertEnter`, `LspAttach` | Fine for current modules |

### Suggestions

```lua
-- Lower the completion delay (default is 100ms)
require('mini.completion').setup({
  delay = { completion = 100, info = 100, signature = 50 }
})

-- Consider adding these popular modules:
require('mini.ai').setup()        -- Extended textobjects
require('mini.surround').setup()  -- Surround actions
require('mini.bracketed').setup() -- Go forward/backward with []
require('mini.icons').setup()     -- Icon provider
```

---

## 7. neogit

**Status:** ✅ Good

Your setup is minimal but functional.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Dependencies | All correct (plenary, diffview, snacks) | Good |
| `auto_close_console` | `false` | README default is `true` - your choice is valid |
| Keys | Basic `<leader>gg`, `<leader>gd`, etc. | Good selection |

### Optional Additions

The README shows many more options you might find useful:

```lua
neogit.setup({
  graph_style = "unicode",  -- prettier git graph (options: ascii, unicode, kitty)
  kind = "split",           -- open in split instead of tab
  commit_editor = {
    staged_diff_split_kind = "auto",
  },
})
```

---

## 8. oil.nvim

**Status:** ✅ Good

Your setup is well-configured with thoughtful customizations.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| `delete_to_trash` | Mac-conditional | Smart approach |
| `watch_for_changes` | `true` | Good for auto-refresh |
| Keymaps | Custom Tab/Shift-Tab navigation | Good UX |
| `highlight_filename` | Custom buffer highlighting | Nice touch |

### Notes

- README recommends `lazy = false` for oil. You use `keys` for lazy-loading which is fine but may cause issues with `:edit <directory>`
- Consider adding `lazy = false` if you want oil to handle directory buffers automatically

---

## 9. sidekick.nvim

**Status:** ✅ Good

Your setup closely matches the recommended configuration.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Mux backend | `tmux` | Correct for tmux users |
| NES keymaps | `<tab>` for jump/apply | Matches recommended |
| CLI keymaps | Comprehensive `<leader>a*` | Well-organized |

### Notes

- README shows `<leader>aa` for toggle; you use `<c-.>` - both are valid
- Your CLI tool selection is good with Claude as the primary

---

## 10. snacks.nvim

**Status:** ⚠️ Missing Features

Your setup is good but missing some recommended enabled features.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Features enabled | notifier, gitbrowse, indent, picker, bigfile, input, image, statuscolumn, scroll | Good selection |
| Missing features | - | `dashboard`, `explorer`, `scope`, `quickfile`, `words` |
| Picker frecency | Enabled | Good choice |

### Suggested Additions

```lua
-- Add these to your snacks.nvim opts:
{
  quickfile = { enabled = true },  -- faster file loading on `nvim file.txt`
  scope = { enabled = true },      -- treesitter-based scope detection
  words = { enabled = true },      -- LSP references navigation with ]] and [[
}
```

---

## 11. nvim-treesitter

**Status:** ✅ Correct Setup

Your setup uses the new `main` branch API correctly.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Branch | `main` | Correct (required for new API) |
| Setup | `ts.setup()` + `ts.install()` | Matches new API |
| On-demand install | FileType autocmd | Good approach |

### Important Notes

- The README explicitly states `main` branch is a **full rewrite** and incompatible with `master`
- You're on the right branch and using the correct API
- Requirements: Neovim 0.11.0+, `tree-sitter-cli` (which you install via mason)

---

## 12. vim-tmux-navigator

**Status:** ✅ Good

Your setup matches the recommended lazy.nvim configuration.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Commands | All 5 TmuxNavigate commands | Complete |
| Keys | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`, `<C-\>` | Standard mappings |
| `lazy = false` | Yes | Correct for this plugin |

### Reminder

Make sure your `~/.tmux.conf` has the matching keybindings:

```tmux
# Smart pane switching with awareness of Vim splits
vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +${vim_pattern}$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
```

---

## 13. which-key.nvim

**Status:** ⚠️ Minimal Config

Your setup is very minimal with only defaults.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| Config | `{}` (empty) | Works but no customization |
| Preset | Not specified | Options: `classic`, `modern`, `helix` |
| Spec | Not specified | README shows adding group descriptions |

### Suggested Additions

```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",  -- or "helix" for a different look
    spec = {
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>s", group = "search" },
      { "<leader>a", group = "ai/sidekick" },
      { "<leader>l", group = "lsp" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
```

---

## 14. mason-lspconfig.nvim

**Status:** ✅ Good

Your setup uses the new v2 API correctly.

| Aspect | Your Config | Recommendation |
|--------|-------------|----------------|
| `automatic_enable` | `true` | Correct default |
| `ensure_installed` | `lua_ls`, `marksman`, `copilot` | Good choices |

### Notes

- `copilot` in ensure_installed may conflict if you're using copilot.lua or copilot.vim which bundle their own LSP
- The plugin now uses `vim.lsp.enable()` under the hood (Neovim 0.11+)

---

## Summary

| Plugin | Status | Action Needed |
|--------|--------|---------------|
| csvview.nvim | ✅ Good | Minor: add comment parser config |
| gitsigns.nvim | ⚠️ Gaps | Add staged signs, text object, update API |
| nvim-lspconfig | ✅ Good | None - modern setup |
| lualine.nvim | ✅ Good | None |
| mason.nvim | ✅ Good | None |
| mini.nvim | ⚠️ Limited | Lower completion delay, consider more modules |
| neogit | ✅ Good | None |
| oil.nvim | ✅ Good | Consider `lazy = false` |
| sidekick.nvim | ✅ Good | None |
| snacks.nvim | ⚠️ Gaps | Enable quickfile, scope, words |
| nvim-treesitter | ✅ Good | None - correct main branch usage |
| vim-tmux-navigator | ✅ Good | None |
| which-key.nvim | ⚠️ Minimal | Add spec/groups, choose preset |
| mason-lspconfig | ✅ Good | Check copilot conflict |

### Legend

- ✅ **Good** - Configuration matches or exceeds recommendations
- ⚠️ **Gaps/Minimal** - Missing recommended features or using outdated patterns

---

## Priority Recommendations

### High Priority (Functional Improvements)

1. **gitsigns.nvim**: Update to newer `nav_hunk()` API and add text object
2. **mini.nvim**: Lower completion delay from 1000ms to 100-300ms
3. **which-key.nvim**: Add group specifications for better discoverability

### Medium Priority (Feature Additions)

1. **snacks.nvim**: Enable `quickfile`, `scope`, and `words` features
2. **oil.nvim**: Consider `lazy = false` for seamless directory handling
3. **mini.nvim**: Consider adding `mini.ai`, `mini.surround`, `mini.icons`

### Low Priority (Nice-to-Have)

1. **csvview.nvim**: Add comment parser configuration
2. **neogit**: Consider `graph_style = "unicode"` for prettier graphs
3. **gitsigns.nvim**: Enable `signs_staged_enable = true`
