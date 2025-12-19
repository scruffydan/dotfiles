# Personal Dotfiles

This is my personal dotfiles repository. These configurations are tailored specifically to my workflow and preferences.

## ⚠️ Warning

**Breaking changes may occur at any time without notice.** This repository is maintained for my personal needs, and I make changes whenever they suit my workflow.

These dotfiles are designed for my personal use and are unlikely to be useful to anyone else. They contain configurations specific to my machine, workflow, and preferences.

### If You Still Want to Use This

If you find something useful here and want to use it:

1. **Fork this repository** - Don't use it directly
2. **Make your own modifications** - Adapt it to your needs
3. **Review changes carefully** - Before pulling in any new commits from upstream, examine what has changed
4. **Expect breaking changes** - I don't maintain backwards compatibility

Seriously though, you're probably better off starting from scratch or finding a more general-purpose dotfiles repository as a base.

## What's Included

- Neovim configuration
- Shell configurations
- Git settings
- Other development environment customizations

## Requirements

### Neovim Configuration

- **ripgrep (rg)** - Required for snacks.nvim picker grep
- **C compiler** (gcc/clang) - Required for treesitter parser compilation (typically pre-installed on macOS and FreeBSD)
- **tree-sitter-cli** (0.25.0 or later) - Required for nvim-treesitter main branch
  - macOS/Linux: Auto-installed by Mason on first launch
  - FreeBSD: `pkg install tree-sitter` (Mason doesn't have FreeBSD binaries)
- **git** - Required for lazy.nvim plugin manager and gitsigns
- **ImageMagick** - Required for snacks.nvim image viewer (non-PNG formats)
  - macOS: `brew install imagemagick`
  - FreeBSD: `pkg install ImageMagick7`
  - Ubuntu/Debian: `apt install imagemagick`
- **awk** - Used in tmux status bar (typically pre-installed on macOS, Linux, and FreeBSD)

### LSP Support

LSP (Language Server Protocol) support is available on macOS, Linux, and Windows via Mason. FreeBSD is not supported as Mason doesn't provide FreeBSD binaries.

**Auto-installed LSPs:**
- `lua_ls` - Lua language server

**Adding more LSPs:**
1. Open Mason UI: `:Mason`
2. Search for desired LSP (e.g., `/pyright`)
3. Press `i` to install
4. Restart Neovim - mason-lspconfig auto-enables installed servers

**Note:** Most LSPs (pyright, ts_ls, bashls, jsonls, yamlls) require Node.js to be installed.

## Neovim Keymaps

Leader key is `<Space>`.

### Navigation

| Keymap | Action |
|--------|--------|
| `<C-h>` | Navigate to left split/pane |
| `<C-j>` | Navigate to split/pane below |
| `<C-k>` | Navigate to split/pane above |
| `<C-l>` | Navigate to right split/pane |
| `<C-\>` | Navigate to previous split/pane |
| `<C-d>` | Scroll down half page (centered) |
| `<C-u>` | Scroll up half page (centered) |
| `<leader>-` | Create horizontal split |
| `<leader>\|` | Create vertical split |

### Tabs

| Keymap | Action |
|--------|--------|
| `gt` | Next tab |
| `gT` | Previous tab |

### File Explorer (Oil)

| Keymap | Action |
|--------|--------|
| `<S-Tab>` | Open Oil file explorer |
| `<Tab>` | Select file/directory (in Oil) |
| `<S-Tab>` | Go to parent directory (in Oil) |
| `<leader>th` | Toggle hidden files (in Oil) |
| `<leader>cd` | Change directory (in Oil) |

### Pickers (Snacks)

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Recent files |
| `<leader>fr` | Registers |
| `<leader>fk` | Keymaps |
| `<leader>fn` | Notification history |
| `<leader>fs` | Spell suggestions |
| `<leader>/` | Search current buffer |

### LSP

| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `gr` | References |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>la` | Code action |
| `<leader>lr` | Rename symbol |
| `<leader>ld` | Diagnostics picker |
| `<leader>lD` | Diagnostic float (at cursor) |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open Neogit |
| `<leader>gd` | Open DiffView |
| `<leader>dc` | Close DiffView |
| `<leader>gp` | Git pull |
| `<leader>gs` | Git status picker |
| `<leader>gB` | Git branches picker |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log (line) |
| `<leader>gf` | Git log (file) |
| `<leader>gD` | Git diff hunks |
| `<leader>gS` | Git stash |
| `<leader>gh` | Preview hunk |
| `<leader>gb` | Git blame |
| `<leader>go` | Open in browser (GitHub) |
| `<leader>ghi` | GitHub issues |
| `<leader>ghp` | GitHub PRs |
| `]c` | Next hunk |
| `[c` | Previous hunk |

### Toggles

| Keymap | Action |
|--------|--------|
| `<leader>tn` | Toggle relative line numbers |
| `<leader>ts` | Toggle spell checking |
| `<leader>tw` | Toggle whitespace display |
| `<leader>th` | Toggle hidden files (Oil) |
| `<leader>tc` | Toggle completion |

### Completion (mini.completion)

| Keymap | Action |
|--------|--------|
| `<C-n>` | Next item |
| `<C-p>` | Previous item |
| `<C-y>` | Confirm selection |
| `<C-e>` | Cancel completion |
| `<C-Space>` | Trigger completion manually |

### Terminal

| Keymap | Action |
|--------|--------|
| `<Esc>` | Exit terminal mode |
| `<Esc><Esc>` | Send Esc to terminal |

### Misc

| Keymap | Action |
|--------|--------|
| `<Esc>` | Clear search highlights |

## Usage

This repository is managed as my personal configuration. If you're me and setting up a new machine, you know what to do. If you're not me, you probably want to look elsewhere.

