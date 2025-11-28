# Neovim Configuration Recommendations

## Current Structure
Your config is minimal and well-organized with two files:
- `nvim/init.lua` - Core settings and keymaps
- `nvim/lua/plugins.lua` - Plugin management via lazy.nvim

---

## Suggested Improvements

### 1. Add a Leader Key - DONE
~~You don't have a leader key defined.~~ - Added space as leader.

### 2. Missing Essential Options - DONE (partial)
Added scrolloff, sidescrolloff, splitright, splitbelow, conditional termguicolors, and clipboard.

Skipped:
- `signcolumn` - not wanted
- `undofile` - not wanted

### 3. Redundant Setting - DONE
~~`vim.cmd('syntax on')` is unnecessary~~ - Removed.

### 4. Package Path Manipulation
The `package.path` line is unnecessary. Lazy.nvim and Neovim's `rtp` handle lua module loading. This line can be removed:
```lua
-- REMOVE THIS LINE:
package.path = package.path .. ';' .. vim.fn.expand('~/dotfiles/nvim/lua/?.lua')
```

### 5. Plugin Suggestions - PARTIAL
Added:
- `telescope.nvim` - Fuzzy finder (Ctrl-P, Space+ff/fg/fb/fh)
- `nvim-tree.lua` - File explorer (Space+e toggle, Space+o focus)

Still available to add:
| Plugin | Purpose |
|--------|---------|
| `nvim-lspconfig` | LSP support |
| `gitsigns.nvim` | Git integration in signcolumn |
| `which-key.nvim` | Shows available keybindings |
| `nvim-autopairs` | Auto-close brackets/quotes |
| `Comment.nvim` | Easy commenting with `gc` |

### 6. LSP Hover Keymap Issue - DONE
~~Dead keymap with no LSP configured~~ - Removed.

### 7. Better Autocommand Grouping - DONE
~~Wrap autocommands in an augroup~~ - Added augroup.

### 8. File Organization
Consider splitting into separate files as the config grows:
```
nvim/
├── init.lua
└── lua/
    ├── options.lua
    ├── keymaps.lua
    ├── autocmds.lua
    └── plugins/
        ├── init.lua
        ├── treesitter.lua
        └── telescope.lua
```

### 9. FZF Directory Hardcoding - DONE
~~Hardcoded ~/.fzf path~~ - Replaced with Telescope.

### 10. Consistent Keymap Style - SKIPPED
Current approach is fine: plugin-specific keys in lazy specs, general keys in init.lua.

---

## Remaining Items

1. Remove unnecessary `package.path` line (option 4)
2. Consider adding more plugins (option 5): LSP, gitsigns, which-key, autopairs, Comment
3. Consider file organization as config grows (option 8)
