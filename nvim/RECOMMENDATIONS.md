# Neovim Configuration Recommendations

## Current Structure
Your config is minimal and well-organized with two files:
- `nvim/init.lua` - Core settings and keymaps
- `nvim/lua/plugins.lua` - Plugin management via lazy.nvim

---

## Suggested Improvements

### 1. Add a Leader Key - DONE
~~You don't have a leader key defined. This is fundamental for custom keymaps:~~
```lua
vim.g.mapleader = " "      -- Space as leader
vim.g.maplocalleader = " "
```

### 2. Missing Essential Options - DONE (partial)
Added scrolloff, sidescrolloff, splitright, splitbelow, conditional termguicolors, and clipboard.

Skipped:
- `signcolumn` - not wanted
- `undofile` - not wanted

### 3. Redundant Setting - DONE
~~Line 5: `vim.cmd('syntax on')` is unnecessary~~ - Removed.

### 4. Package Path Manipulation
Line 83 is unnecessary. Lazy.nvim and Neovim's `rtp` handle lua module loading. This line can be removed:
```lua
-- REMOVE THIS LINE:
package.path = package.path .. ';' .. vim.fn.expand('~/dotfiles/nvim/lua/?.lua')
```

### 5. Plugin Suggestions

Your plugin set is minimal. Consider adding:

| Plugin | Purpose |
|--------|---------|
| `telescope.nvim` | Modern fuzzy finder (better than fzf.vim in Neovim) |
| `nvim-lspconfig` | LSP support |
| `gitsigns.nvim` | Git integration in signcolumn |
| `which-key.nvim` | Shows available keybindings |
| `nvim-autopairs` | Auto-close brackets/quotes |
| `Comment.nvim` | Easy commenting with `gc` |

### 6. LSP Hover Keymap Issue - DONE
~~Line 80 maps `<F5>` to `vim.lsp.buf.hover`, but you have no LSP configured.~~ - Removed.

### 7. Better Autocommand Grouping - DONE
~~Wrap your autocommands in an augroup to prevent duplicates on config reload.~~ - Added augroup.

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
        └── fzf.lua
```

### 9. FZF Directory Hardcoding - DONE
~~Line 34: `dir = "~/.fzf"` assumes fzf is installed via the fzf repo's install script.~~ - Now managed by lazy.nvim.

### 10. Consistent Keymap Style - SKIPPED
Current approach is fine: plugin-specific keys in lazy specs, general keys in init.lua.

---

## Remaining Items

1. Remove unnecessary `package.path` line (option 4)
2. Consider adding suggested plugins (option 5)
3. Consider file organization as config grows (option 8)
