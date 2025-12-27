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

- **Nerd Font** - Required for Neovide and icons in which-key, Oil, and other plugins
  - macOS: `brew install --cask font-sauce-code-pro-nerd-font`
  - Linux/Windows/FreeBSD: Download from [Nerd Fonts](https://www.nerdfonts.com/font-downloads)

### Ghostty Terminal

- **SauceCodePro Nerd Font** - Required for icons (same as Neovim requirement)
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
- **bash** - Required on FreeBSD for vscode-diff.nvim build script
  - FreeBSD: `pkg install bash`
- **awk** - Used in tmux status bar (typically pre-installed on macOS, Linux, and FreeBSD)

### LSP Support

LSP (Language Server Protocol) support is available on macOS, Linux, and Windows via Mason. FreeBSD is not supported as Mason doesn't provide FreeBSD binaries - the LSP configuration is automatically skipped on unsupported platforms.

**Auto-installed LSPs:**
- `lua_ls` - Lua language server
- `marksman` - Markdown language server
- `copilot` - GitHub Copilot language server (requires Node.js)

**Adding more LSPs:**
1. Open Mason UI: `:Mason`
2. Search for desired LSP (e.g., `/pyright`)
3. Press `i` to install
4. Restart Neovim - mason-lspconfig auto-enables installed servers

**Note:** Most LSPs (pyright, ts_ls, bashls, jsonls, yamlls) require Node.js to be installed.

### Optional Dependencies

- **Node.js** - Required for GitHub Copilot (both LSP and inline completions). If Node.js is not installed:
  - Copilot LSP is automatically skipped (not added to Mason's install list)
  - `copilot.vim` plugin shows a warning and doesn't load
  - All other Neovim functionality works normally

## Tmux Keybindings

Prefix key is `<C-a>`.

### General

| Keymap | Action |
|--------|--------|
| `<C-a>` | Prefix key |
| `<C-a> <C-a>` | Send prefix to application |
| `<C-a> r` | Reload tmux config and resync client |
| `<C-a> m` | Toggle mouse mode |

### Sessions

| Keymap | Action |
|--------|--------|
| `<C-a> .` | Rename session |

### Windows

| Keymap | Action |
|--------|--------|
| `<C-a> c` | Create new window (in current directory) |
| `<C-a> n` | Next window (repeatable) |
| `<C-a> N` | Previous window (repeatable) |
| `<C-a> ,` | Rename window (default tmux binding) |

### Panes

| Keymap | Action |
|--------|--------|
| `<C-a> \|` or `<C-a> \` | Split pane vertically (in current directory) |
| `<C-a> -` | Split pane horizontally (in current directory) |
| `<C-a> h` | Select pane left (repeatable) |
| `<C-a> j` | Select pane down (repeatable) |
| `<C-a> k` | Select pane up (repeatable) |
| `<C-a> l` | Select pane right (repeatable) |
| `<C-a> H` | Resize pane left (repeatable) |
| `<C-a> J` | Resize pane down (repeatable) |
| `<C-a> K` | Resize pane up (repeatable) |
| `<C-a> L` | Resize pane right (repeatable) |

### Vim-Tmux Navigator Integration

| Keymap | Action |
|--------|--------|
| `<C-h>` | Navigate to left pane/split (vim-aware) |
| `<C-j>` | Navigate to pane/split below (vim-aware) |
| `<C-k>` | Navigate to pane/split above (vim-aware) |
| `<C-l>` | Navigate to right pane/split (vim-aware) |
| `<C-\>` | Navigate to previous pane/split (vim-aware) |

### Copy Mode (Vi)

| Keymap | Action |
|--------|--------|
| `<C-a> Escape` | Enter copy mode |
| `<C-a> p` | Paste from buffer |
| `<C-a> P` | Choose buffer to paste |
| `v` (in copy mode) | Begin selection |
| `y` (in copy mode) | Copy selection |
| `<C-c>` (in copy mode) | Copy selection |

### Popup

| Keymap | Action |
|--------|--------|
| `<C-a> `` ` | Display popup terminal (90% size, current directory) |
| `<C-a> ~` | Display popup terminal (90% size, current directory) |

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
| `<leader>\|` or `<leader>\` | Create vertical split |

### Tabs

| Keymap | Action |
|--------|--------|
| `<leader>T` | New tab |
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
| `gr` | References (picker) |
| `K` | Hover documentation |
| `<C-k>` | Signature help (normal and insert mode) |
| `<leader>la` | Code action (normal and visual mode) |
| `<leader>lr` | Rename symbol |
| `<leader>ld` | Diagnostic float (at cursor) |
| `<leader>lD` | Diagnostics picker (buffer) |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `<leader>lc` | Toggle CSV view |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open Neogit |
| `<leader>gp` | Git pull |
| `<leader>gs` | Git status picker |
| `<leader>gB` | Git branches picker |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log (line) |
| `<leader>gf` | Git log (file) |
| `<leader>gD` | Git diff hunks picker |
| `<leader>gS` | Git stash picker |
| `<leader>gh` | Preview hunk |
| `<leader>gb` | Git blame |
| `<leader>go` | Open in browser (GitHub) |
| `<leader>ghi` | GitHub issues |
| `<leader>ghp` | GitHub PRs |
| `]h` | Next hunk |
| `[h` | Previous hunk |

### Treesitter Text Objects

Provides syntax-aware text objects using treesitter. These work with any operator (`d`, `y`, `c`, `v`, etc.) and allow you to select, delete, yank, or change code structures based on their semantic meaning rather than just brackets or whitespace.

**Selection modes:** Functions and classes use linewise selection (`V`) for outer objects, making `daf` delete the entire function including surrounding blank lines. Parameters use charwise selection (`v`).

**Text Object Selection** (use with operators like `d`, `y`, `c`, or in visual mode):

| Keymap | Action |
|--------|--------|
| `af`/`if` | Outer/inner function (outer is linewise) |
| `ac`/`ic` | Outer/inner class (outer is linewise) |
| `aa`/`ia` | Outer/inner parameter/argument |
| `al`/`il` | Outer/inner loop |
| `ai`/`ii` | Outer/inner conditional |
| `a/`/`i/` | Outer/inner comment |

**Movement** (jump between text objects, works in normal, visual, and operator-pending modes):

| Keymap | Action |
|--------|--------|
| `]f`/`[f` | Next/previous function start |
| `]F`/`[F` | Next/previous function end |
| `]c`/`[c` | Next/previous class start |
| `]C`/`[C` | Next/previous class end |
| `]a`/`[a` | Next/previous parameter |

**Swap** (reorder parameters/arguments):

| Keymap | Action |
|--------|--------|
| `<leader>sn` | Swap parameter with next |
| `<leader>sp` | Swap parameter with previous |

### Diff (vscode-diff.nvim)

| Keymap | Action |
|--------|--------|
| `<leader>dd` | Diff explorer (git status) |
| `<leader>df` | Diff current file vs HEAD |
| `<leader>dh` | Diff current file vs HEAD~1 |
| `<leader>db` | Diff vs default branch (main/master) |
| `]c` | Next hunk (in diff view) |
| `[c` | Previous hunk (in diff view) |
| `]f` | Next file (in explorer) |
| `[f` | Previous file (in explorer) |
| `do` | Get change from other buffer |
| `dp` | Put change to other buffer |
| `e` | Toggle list/tree view (in explorer) |
| `q` | Close diff view (in diff tab) |

### Toggles

| Keymap | Action |
|--------|--------|
| `<leader>tn` | Toggle relative line numbers |
| `<leader>ts` | Toggle spell checking |
| `<leader>tw` | Toggle whitespace display (cycles: default → all → off) |
| `<leader>th` | Toggle hidden files (Oil) |
| `<leader>tc` | Cycle completion (copilot/native/off) |

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

### Neovide (GUI)

| Keymap | Action |
|--------|--------|
| `<D-v>` | Paste from clipboard |
| `<D-c>` | Copy to clipboard |
| `<D-x>` | Cut to clipboard |
| `<D-a>` | Select all |
| `<D-=>` | Zoom in |
| `<D-->` | Zoom out |
| `<D-0>` | Reset zoom |

### Sidekick (AI CLI Integration)

| Keymap | Action |
|--------|--------|
| `<C-.>` | Toggle Sidekick CLI |
| `<leader>ao` | Open OpenCode |
| `<leader>ac` | Open Claude |
| `<leader>as` | Select CLI tool |
| `<leader>ap` | Select prompt |
| `<leader>at` | Send this (selection/position) |
| `<leader>af` | Send file |
| `<leader>av` | Send visual selection |
| `<leader>ae` | Explain this |
| `<leader>ar` | Review file |
| `<leader>aF` | Fix this |
| `<leader>ad` | Fix diagnostics (buffer) |
| `<leader>aD` | Fix diagnostics (all) |
| `<leader>ai` | Document this |
| `<leader>az` | Optimize this |
| `<leader>aT` | Write tests for this |
| `<leader>an` | Toggle NES (Next Edit Suggestions) |

### Copilot Inline Completion

| Keymap | Mode | Action |
|--------|------|--------|
| `<Tab>` | Insert | Accept full completion (or NES, or normal Tab) |
| `<M-w>` | Insert | Accept next word only |
| `<M-l>` | Insert | Accept next line only |
| `<M-]>` | Insert | Next suggestion |
| `<M-[>` | Insert | Previous suggestion |
| `<M-Esc>` | Insert | Dismiss suggestion |
| `<leader>cp` | Normal | Open Copilot panel (shows up to 10 completions) |

### Misc

| Keymap | Action |
|--------|--------|
| `<Esc>` | Clear search highlights |
| `<leader>?` | Buffer local keymaps |

## Usage

This repository is managed as my personal configuration. If you're me and setting up a new machine, you know what to do. If you're not me, you probably want to look elsewhere.

