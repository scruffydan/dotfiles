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
- **fd** - Required for snacks.nvim explorer picker
- **C compiler** (gcc/clang) - Required for treesitter parser compilation (typically pre-installed on macOS and FreeBSD)
- **tree-sitter-cli** (0.25.0 or later) - Required for nvim-treesitter main branch
  - macOS/Linux: Auto-installed by Mason on first launch
  - FreeBSD: Install via `pkg` (Mason doesn't have FreeBSD binaries)
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
- `harper_ls` - Grammar checker (offline, privacy-first)
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

**Prefix:** `<C-a>` (Ctrl+a)

### General

| Keymap | Action |
|--------|--------|
| `<prefix>` | Prefix key |
| `<prefix> <prefix>` | Send prefix to application |
| `<prefix> r` | Reload tmux config and resync client |
| `<prefix> m` | Toggle mouse mode |
| `<M-d>` | Display menu popup |

### Sessions

| Keymap | Action |
|--------|--------|
| `<prefix> .` | Rename session |

### Windows

| Keymap | Action |
|--------|--------|
| `<prefix> c` | Create new window (in current directory) |
| `<prefix> n` | Next window (repeatable) |
| `<prefix> N` | Previous window (repeatable) |
| `<prefix> ,` | Rename window (default tmux binding) |

### Panes

| Keymap | Action |
|--------|--------|
| `<prefix> \|` or `<prefix> \` | Split pane vertically (in current directory) |
| `<prefix> -` | Split pane horizontally (in current directory) |
| `<prefix> h` | Select pane left (repeatable) |
| `<prefix> j` | Select pane down (repeatable) |
| `<prefix> k` | Select pane up (repeatable) |
| `<prefix> l` | Select pane right (repeatable) |
| `<prefix> H` | Resize pane left (repeatable) |
| `<prefix> J` | Resize pane down (repeatable) |
| `<prefix> K` | Resize pane up (repeatable) |
| `<prefix> L` | Resize pane right (repeatable) |

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
| `<prefix> Escape` | Enter copy mode |
| `<prefix> p` | Paste from buffer |
| `<prefix> P` | Choose buffer to paste |
| `v` (in copy mode) | Begin selection |
| `y` (in copy mode) | Copy selection |
| `<C-c>` (in copy mode) | Copy selection |

### Popup

| Keymap | Action |
|--------|--------|
| ``<prefix> ` ``  | Display popup terminal (90% size, current directory) |
| `<prefix> ~` | Display popup terminal (90% size, current directory) |

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
| `g.` | Toggle hidden files (in Oil) |
| `<leader>t.` | Toggle hidden files (in Oil) |
| `<leader>cd` | Change CWD (in Oil) |

### Pickers (Snacks) - Workspace

| Keymap | Action |
|--------|--------|
| `<leader><space>` | Smart find files (buffers + recent + files) |
| `<leader>e` | File explorer (Snacks) |
| `<leader>fd` | Diagnostics (workspace) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fh` | Recent files |
| `<leader>fm` | Man pages |
| `<leader>fp` | Projects |
| `<leader>fw` | Grep word under cursor (or visual selection) |

**Picker Actions** (available in any picker):

| Keymap | Action |
|--------|--------|
| `<C-q>` | Send selected items (or all if none selected) to quickfix list |
| `<Tab>` | Toggle selection on current item |
| `<C-a>` | Select all items |

### Quickfix List

| Command | Action |
|---------|--------|
| `:cn` | Next quickfix item |
| `:cp` | Previous quickfix item |
| `:cnfile` | First quickfix item in next file |
| `:cdo {cmd}` | Execute command on each quickfix item (e.g., `:cdo s/foo/bar/g`) |
| `:cfdo {cmd}` | Execute command on each file in quickfix list (e.g., `:cfdo %s/foo/bar/g`) |

### Search (Snacks) - Current/Open Buffers

| Keymap | Action |
|--------|--------|
| `<leader>sb` | Buffers |
| `<leader>sc` | Commands |
| `<leader>sC` | Command history |
| `<leader>sd` | Diagnostics (buffer) |
| `<leader>sg` | Grep buffer |
| `<leader>sG` | Grep open buffers |
| `<leader>sh` | Help tags |
| `<leader>sj` | Jump list |
| `<leader>sk` | Keymaps |
| `<leader>sm` | Marks |
| `<leader>sn` | Notification history |
| `<leader>sp` | Pickers (list all) |
| `<leader>sq` | Quickfix list |
| `<leader>sr` | Registers |
| `<leader>sR` | Resume last picker |
| `<leader>ss` | Treesitter symbols |
| `<leader>su` | Undo history |
| `<leader>sw` | Spell suggestions |

### Spell Checking

Neovim includes both built-in Vim spell checking and Harper grammar checking via LSP.

**Vim Spell Checker:**

| Keymap | Action |
|--------|--------|
| `<leader>ts` | Toggle spell checking on/off |
| `<leader>sw` | Spell suggestions (Snacks picker) |
| `z=` | Spell suggestions (classic Vim menu) |
| `]s` | Jump to next misspelled word |
| `[s` | Jump to previous misspelled word |
| `zg` | Add word to dictionary |
| `zug` | Undo adding word to dictionary |
| `zw` | Mark word as incorrect |

**Harper Grammar Checker (LSP):**
- Runs automatically on text and markdown files
- Checks grammar, repeated words, long sentences, and more
- Uses same custom dictionary as Vim spell checker (`~/dotfiles/nvim/spell/en.utf-8.add`)
- Fast, offline, privacy-first (< 10ms suggestions)
- Restart after adding words: `:LspRestart harper_ls`

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
| `<leader>lf` | Find definitions (picker) |
| `<leader>lr` | References (picker) |
| `<leader>lR` | Rename symbol |
| `<leader>ld` | Diagnostic float (at cursor) |
| `<leader>li` | Incoming calls (who calls this) |
| `<leader>lo` | Outgoing calls (what this calls) |
| `<leader>ls` | Document symbols |
| `<leader>lS` | Workspace symbols |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open Neogit |
| `<leader>gp` | Git pull |
| `<leader>gs` | Git status picker |
| `<leader>gb` | Git branches picker |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log (line) |
| `<leader>gf` | Git log (file) |
| `<leader>gd` | Git diff hunks picker |
| `<leader>gS` | Git stash picker |
| `<leader>gH` | Preview hunk |
| `<leader>gB` | Git blame |
| `<leader>go` | Open in browser (GitHub) |
| `<leader>ghi` | GitHub issues |
| `<leader>ghp` | GitHub PRs |
| `]h` | Next hunk |
| `[h` | Previous hunk |

### Treesitter Text Objects

Provides syntax-aware text objects using treesitter. These work with any operator (`d`, `y`, `c`, `v`, etc.) and allow you to select, delete, yank, or change code structures based on their semantic meaning rather than just brackets or whitespace.

**Text Object Selection** (use with operators like `d`, `y`, `c`, or in visual mode):

| Keymap | Action |
|--------|--------|
| `af`/`if` | Outer/inner function |
| `ac`/`ic` | Outer/inner class |
| `ap`/`ip` | Outer/inner parameter |
| `aa`/`ia` | Outer/inner attribute (decorators, annotations) |
| `al`/`il` | Outer/inner loop |
| `ai`/`ii` | Outer/inner conditional |
| `a/`/`i/` | Outer/inner comment |
| `ab`/`ib` | Outer/inner block |
| `a=`/`i=` | Outer/inner assignment |
| `in` | Number |
| `ar`/`ir` | Outer/inner return statement |

**Movement** (jump between text objects, works in normal, visual, and operator-pending modes):

| Keymap | Action |
|--------|--------|
| `]f`/`[f` | Next/previous function start |
| `]F`/`[F` | Next/previous function end |
| `]c`/`[c` | Next/previous class start |
| `]C`/`[C` | Next/previous class end |
| `]p`/`[p` | Next/previous parameter |
| `]a`/`[a` | Next/previous attribute |
| `]b`/`[b` | Next/previous block start |
| `]B`/`[B` | Next/previous block end |
| `]l`/`[l` | Next/previous loop start |
| `]L`/`[L` | Next/previous loop end |
| `]i`/`[i` | Next/previous conditional start |
| `]I`/`[I` | Next/previous conditional end |
| `]/`/`[/` | Next/previous comment start |
| `]?`/`[?` | Next/previous comment end |
| `]=`/`[=` | Next/previous assignment |
| `]n`/`[n` | Next/previous number |
| `]r`/`[r` | Next/previous return |

### Diff (vscode-diff.nvim)

| Keymap | Action |
|--------|--------|
| `<leader>dd` | Diff explorer (git status) |
| `<leader>df` | Diff current file vs HEAD |
| `<leader>dh` | Diff current file vs HEAD~1 |
| `<leader>db` | Diff vs default branch (main/master) |
| `]c` or `]h` | Next hunk (in diff view) |
| `[c` or `[h` | Previous hunk (in diff view) |
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
| `<leader>ts` | Toggle spell checking (Vim built-in) |
| `<leader>tw` | Toggle whitespace display (cycles: default → all → off) |
| `<leader>t.` | Toggle hidden files (Oil) |
| `<leader>tc` | Cycle completion (copilot/native/off) |
| `<leader>tm` | Toggle Markdown render |
| `<leader>tv` | Toggle CSV view |

### Completion (mini.completion)

| Keymap | Action |
|--------|--------|
| `<C-n>` | Next item |
| `<C-p>` | Previous item |
| `<C-y>` | Confirm selection |
| `<C-e>` | Cancel completion |
| `<C-Space>` | Trigger completion manually |

### Surround (mini.surround)

Surround text objects with brackets, quotes, tags, and more. All actions are dot-repeatable.

| Keymap | Action |
|--------|--------|
| `sa` | Add surrounding (e.g., `saiw)` surround word with parens, `sa2j"` surround 2 lines with quotes) |
| `sd` | Delete surrounding (e.g., `sd"` delete surrounding quotes, `sdf` delete surrounding function call) |
| `sr` | Replace surrounding (e.g., `sr)"` replace parens with quotes, `sr({` replace parens with braces + space) |
| `sf` | Find surrounding (to the right) |
| `sF` | Find surrounding (to the left) |
| `sh` | Highlight surrounding |

**Surrounding characters:**
- `(`, `)`, `[`, `]`, `{`, `}`, `<`, `>` - Bracket pairs (opening adds space, closing doesn't)
- `'`, `"`, `` ` `` - Quote characters
- `f` - Function call (prompts for function name when adding)
- `t` - HTML/XML tag (prompts for tag name when adding)
- `?` - Interactive (prompts for left and right parts)

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
| `<leader>ag` | Review git changes |
| `<leader>aF` | Fix this |
| `<leader>ad` | Fix diagnostics (buffer) |
| `<leader>aD` | Fix diagnostics (all) |
| `<leader>ai` | Document this |
| `<leader>az` | Optimize this |
| `<leader>aT` | Write tests for this |
| `<leader>tN` | Toggle NES (Next Edit Suggestions) |

### Tab Key Behavior

The Tab and Shift+Tab keys have smart, context-aware behavior:

**Insert Mode:**
- `<Tab>`: Accept Copilot suggestion → Apply NES → Normal Tab
- `<S-Tab>`: Dedent (unindent) current line

**Normal Mode:**
- `<Tab>`: Apply NES → Normal Tab  
- `<S-Tab>`: Open Oil file explorer

**In Oil.nvim:**
- `<Tab>`: Select file/directory
- `<S-Tab>`: Go to parent directory

### Copilot Inline Completion

| Keymap | Mode | Action |
|--------|------|--------|
| `<Tab>` | Insert | Accept full completion (or NES, or normal Tab) |
| `<M-w>` | Insert | Accept next word only |
| `<M-l>` | Insert | Accept next line only |
| `<M-]>` | Insert | Next suggestion |
| `<M-[>` | Insert | Previous suggestion |
| `<M-Esc>` | Insert | Dismiss suggestion |
| `<leader>ghP` | Normal | Open Copilot panel (shows up to 10 completions) |

### Misc

| Keymap | Action |
|--------|--------|
| `<Esc>` | Clear search highlights |
| `<leader>?` | Buffer local keymaps |

## Usage

This repository is managed as my personal configuration. If you're me and setting up a new machine, you know what to do. If you're not me, you probably want to look elsewhere.

