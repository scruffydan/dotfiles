# Neovim Configuration Recommendations

## Current Structure
Your config is minimal and well-organized with two files:
- `nvim/init.lua` - Core settings and keymaps
- `nvim/lua/plugins.lua` - Plugin management via lazy.nvim

---

## Suggested Improvements

### 1. Add a Leader Key
You don't have a leader key defined. This is fundamental for custom keymaps:
```lua
vim.g.mapleader = " "      -- Space as leader
vim.g.maplocalleader = " "
```

### 2. Missing Essential Options
```lua
vim.opt.termguicolors = true   -- True color support (important for themes)
vim.opt.signcolumn = "yes"     -- Always show signcolumn (prevents text shift)
vim.opt.scrolloff = 8          -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8      -- Keep 8 columns visible left/right
vim.opt.splitright = true      -- Open vertical splits to the right
vim.opt.splitbelow = true      -- Open horizontal splits below
vim.opt.undofile = true        -- Persistent undo history
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
```

### 3. Redundant Setting
Line 5: `vim.cmd('syntax on')` is unnecessary - Neovim enables syntax highlighting by default, and you're using Treesitter anyway.

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
| `nvim-lspconfig` | LSP support (you have `vim.lsp.buf.hover` mapped but no LSP configured) |
| `gitsigns.nvim` | Git integration in signcolumn |
| `which-key.nvim` | Shows available keybindings |
| `nvim-autopairs` | Auto-close brackets/quotes |
| `Comment.nvim` | Easy commenting with `gc` |

### 6. LSP Hover Keymap Issue
Line 80 maps `<F5>` to `vim.lsp.buf.hover`, but you have no LSP configured. This keymap will do nothing. Either:
- Remove the keymap, or
- Add `nvim-lspconfig` and configure language servers

### 7. Better Autocommand Grouping
Wrap your autocommands in an augroup to prevent duplicates on config reload:
```lua
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('highlight CursorLine guibg=#1D1E19 ctermbg=236')
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('highlight CursorLine guibg=NONE ctermbg=NONE')
  end,
})
```

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

### 9. FZF Directory Hardcoding
Line 34: `dir = "~/.fzf"` assumes fzf is installed via the fzf repo's install script. If you use Homebrew, this path won't exist. Consider removing the `dir` option and letting lazy.nvim manage it.

### 10. Consistent Keymap Style
You mix `vim.keymap.set` (line 56, 80) with keys in lazy plugin specs (line 39-41). Both work, but consolidating to one style improves maintainability.

---

## Priority Fixes

1. Add leader key (`vim.g.mapleader = " "`)
2. Add `vim.opt.termguicolors = true`
3. Remove dead LSP keymap or add LSP config
4. Remove redundant `vim.cmd('syntax on')`
5. Remove unnecessary `package.path` line
