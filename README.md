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

### Terminal Requirements

- **Kitty Graphics Protocol support** - Required for image previews in Neovim (Oil, Snacks image viewer)
  - Supported terminals: ghostty, kitty, wezterm (limited)
  - Your terminal (ghostty) supports this

### Tmux Requirements

- **tmux** (>= 3.2) - Required for popup support
- **fzf** - Required for fuzzy finding sessions
- **sed** & **grep** - Required for filtering session list (standard on most systems)

### Neovim Dependencies

- **SauceCodePro Nerd Font** - Required for icons (same as Neovim requirement)
- **ripgrep (rg)** - Required for snacks.nvim picker grep and grug-far.nvim search/replace
- **fd** - Required for snacks.nvim explorer picker
- **C compiler** (gcc/clang) - Required for treesitter parser compilation (typically pre-installed on macOS and FreeBSD)
- **tree-sitter-cli** (0.25.0 or later) - Required for nvim-treesitter main branch
  - macOS/Linux: Auto-installed by Mason on first launch
  - FreeBSD: Install via `pkg` (Mason doesn't have FreeBSD binaries)
- **git** - Required for lazy.nvim plugin manager and gitsigns
- **ImageMagick** - Required for snacks.nvim image rendering (non-PNG formats, enables image previews in Oil with `<C-p>`)
  - macOS: `brew install imagemagick`
  - FreeBSD: `pkg install ImageMagick7`
  - Ubuntu/Debian: `apt install imagemagick`
- **bash** - Required on FreeBSD for codediff.nvim build script (no pre-built FreeBSD binaries)
  - FreeBSD: `pkg install bash`
- **awk** - Used in tmux status bar (typically pre-installed on macOS, Linux, and FreeBSD)

### LSP Support

LSP (Language Server Protocol) support is available on macOS, Linux, and Windows via Mason. FreeBSD is not supported as Mason doesn't provide FreeBSD binaries - the LSP configuration is automatically skipped on unsupported platforms.

**Auto-installed LSPs:**
- `lua_ls` - Lua language server
- `marksman` - Markdown language server
- `harper_ls` - Grammar checker for comments and markdown
- `bashls` - Bash language server (uses shellcheck for diagnostics)
- `shellcheck` - Shell script linter (used by bashls)

**How it works:**
- `nvim-lspconfig` provides default configs (cmd, filetypes, root_markers) for 300+ servers
- `mason-lspconfig` auto-enables servers installed via Mason
- Custom settings go in `nvim/after/lsp/<server_name>.lua` (overrides defaults)

**Adding more LSPs:**

1. Install the LSP server via Mason: `:Mason` -> search -> `i` to install
2. Restart Neovim - the server will be auto-enabled with nvim-lspconfig defaults
3. (Optional) Add custom settings in `nvim/after/lsp/<server_name>.lua`:
   ```lua
   return {
     settings = { ... },  -- Only specify what you want to customize
   }
   ```

**Note:** Most LSPs (pyright, ts_ls, bashls, jsonls, yamlls) require Node.js to be installed.

### Optional Dependencies

- **Node.js** - Required for GitHub Copilot (both LSP and inline completions). If Node.js is not installed, `copilot.vim` shows a warning and doesn't load. All other Neovim functionality works normally.

### GitHub Copilot Setup

GitHub Copilot provides two features:
- **Inline completions** - Ghost text suggestions as you type (via `copilot.vim`)
- **NES (Next Edit Suggestions)** - Predictive multi-location edits (via `copilot-language-server`)

**Setup steps:**
1. Authenticate with GitHub: `:Copilot auth`
2. Install the Copilot LSP for NES: `:MasonInstall copilot`
3. Restart Neovim

**Notes:**
- Inline completions work immediately after step 1
- NES requires both steps 1 and 2
- Use `<leader>tc` to toggle completion menu (blink/off)
- Use `<leader>tgc` to toggle Copilot ghost text (inline suggestions)
- Use `<leader>tgn` to toggle NES (Next Edit Suggestions)

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
| `<prefix> <C-s>` | Switch session (fuzzy finder) |

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
| `<prefix> {` | Swap pane up (repeatable) |
| `<prefix> }` | Swap pane down (repeatable) |

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

### Window Management (Ctrl-W)

| Keymap | Action |
|--------|--------|
| `<C-w>s` | Split window horizontally |
| `<C-w>v` | Split window vertically |
| `<C-w>w` | Cycle to next window |
| `<C-w>W` | Cycle to previous window |
| `<C-w>h/j/k/l` | Move to left/down/up/right window |
| `<C-w>H/J/K/L` | Move window to far left/bottom/top/right |
| `<C-w>r` | Rotate windows downward/rightward |
| `<C-w>R` | Rotate windows upward/leftward |
| `<C-w>x` | Exchange current window with next |
| `<C-w>=` | Make all windows equal size |
| `<C-w>_` | Maximize window height |
| `<C-w>\|` | Maximize window width |
| `<C-w>+` / `<C-w>-` | Increase/decrease window height |
| `<C-w>>` / `<C-w><` | Increase/decrease window width |
| `<C-w>o` | Close all other windows (`:only`) |
| `<C-w>c` | Close current window |
| `<C-w>q` | Quit current window |
| `<C-w>T` | Move current window to new tab |

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
| `<M-h>` | Toggle hidden files (in Oil) |
| `<leader>cd` | Change CWD to current directory (works globally and in Oil) |

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

**Picker Actions** (available in file-based pickers):

| Keymap | Action |
|--------|--------|
| `<M-h>` | Toggle hidden files (dotfiles) |
| `<M-i>` | Toggle ignored files (gitignored) |
| `<C-q>` | Send selected items (or all if none selected) to quickfix list |
| `<Tab>` | Toggle selection on current item |
| `<C-a>` | Select all items |

**Delete Actions** (picker-specific):

| Picker | Keymap | Action |
|--------|--------|--------|
| Buffers | `<C-x>`, `dd` | Delete buffer |
| Marks | `<C-x>` | Delete mark |
| Explorer | `d` | Delete file/directory |
| Git Branches | `<C-x>` | Delete branch |

Use `<Tab>` to select multiple items, then delete to remove them all at once.

### Quickfix List

| Keymap | Action |
|--------|--------|
| `<leader>qo` | Open quickfix list |
| `<leader>qc` | Close quickfix window |
| `<leader>qC` | Clear quickfix list |
| `]q` | Next quickfix item |
| `[q` | Previous quickfix item |
| `]Q` | Last quickfix item |
| `[Q` | First quickfix item |

**Commands:**

| Command | Action |
|---------|--------|
| `:copen` | Open quickfix window |
| `:cclose` | Close quickfix window |
| `:cw` | Open quickfix window if there are entries |
| `:cn` | Next quickfix item |
| `:cp` | Previous quickfix item |
| `:cnfile` | First quickfix item in next file |
| `:cdo {cmd}` | Execute command on each quickfix item (e.g., `:cdo s/foo/bar/g`) |
| `:cfdo {cmd}` | Execute command on each file in quickfix list (e.g., `:cfdo %s/foo/bar/g`) |
| `:call setqflist([])` | Clear quickfix list |

### Trouble

Trouble provides a pretty list for diagnostics, references, quickfix, and location lists.

| Keymap | Action |
|--------|--------|
| `<leader>xx` | Toggle all diagnostics |
| `<leader>xX` | Toggle buffer diagnostics |
| `<leader>xs` | Toggle document symbols (sidebar) |
| `<leader>xl` | Toggle LSP definitions/references (right panel) |
| `<leader>xL` | Toggle location list |
| `<leader>xq` | Toggle quickfix list |

**In Trouble window:**

| Keymap | Action |
|--------|--------|
| `q` | Close |
| `<CR>` | Jump to item |
| `o` | Jump and close |
| `p` | Preview |
| `P` | Toggle auto-preview |
| `r` | Refresh |
| `?` | Help |
| `zo`/`zc` | Open/close fold |
| `zM`/`zR` | Close/open all folds |

### Search (Snacks) - Current/Open Buffers

| Keymap | Action |
|--------|--------|
| `<leader>sb` | Buffers |
| `<leader>sc` | Commands |
| `<leader>sC` | Command history |
| `<leader>sd` | Diagnostics (buffer) |
| `<leader>sf` | Set filetype |
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

### Search and Replace (grug-far)

| Keymap | Action |
|--------|--------|
| `<leader>Sr` | Search and replace |
| `<leader>Sw` | Search and replace word under cursor |
| `<leader>Sf` | Search and replace in current file |

**In grug-far buffer** (mappings use `<localleader>`; your `maplocalleader` is set to `\\` by default in `nvim/init.lua`):

| Keymap | Action |
|--------|--------|
| `<localleader>r` | Execute replace |
| `<localleader>q` | Send to quickfix list |
| `<localleader>s` | Sync all changes |
| `<localleader>l` | Sync current line |
| `<localleader>c` | Close buffer |
| `<localleader>t` | Open history |
| `<localleader>a` | Add to history |
| `<localleader>f` | Refresh search |
| `<localleader>o` | Open location (keep focus) |
| `<localleader>e` | Swap engine (ripgrep/ast-grep) |
| `<localleader>w` | Toggle show command |
| `<localleader>i` | Preview location |
| `<enter>` | Go to location |
| `<up>/<down>` | Open next/previous location |
| `g?` | Show help |
| `<tab>/<s-tab>` | Next/previous input field |

### Spell Checking

Spell checking is enabled by default using Neovim's built-in spell checker. Harper LSP provides grammar checking (not spelling) for code comments and markdown.

| Keymap | Action |
|--------|--------|
| `<leader>ts` | Toggle spell checking on/off |
| `<leader>th` | Toggle Harper grammar checker |
| `<leader>sw` | Spell suggestions (Snacks picker) |
| `z=` | Spell suggestions (classic Vim menu) |
| `]s` | Jump to next misspelled word |
| `[s` | Jump to previous misspelled word |
| `zg` | Add word to dictionary (`~/dotfiles/nvim/spell/en.utf-8.add`) |
| `zug` | Undo adding word to dictionary |
| `zw` | Mark word as incorrect |

### LSP

Neovim 0.11+ provides built-in LSP keymaps. Custom keymaps are defined in `nvim/lua/lsp.lua`.

**Built-in Keymaps (Neovim 0.11+ defaults):**

| Keymap | Action |
|--------|--------|
| `K` | Hover documentation |
| `gra` | Code action (normal and visual mode) |
| `grn` | Rename symbol |
| `grr` | References |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `gO` | Document symbols |
| `<C-s>` | Signature help (insert mode) |

**Custom Keymaps:**

| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `<leader>la` | Code action (normal and visual mode) |
| `<leader>lR` | Rename symbol |
| `<leader>lf` | Find definitions (Snacks picker) |
| `<leader>lr` | References (Snacks picker) |
| `<leader>li` | Incoming calls (who calls this) |
| `<leader>lo` | Outgoing calls (what this calls) |
| `<leader>lI` | Implementations (Snacks picker) |
| `<leader>ly` | Type definitions (Snacks picker) |
| `<leader>ls` | Document symbols (Snacks picker) |
| `<leader>lS` | Workspace symbols (Snacks picker) |
| `<leader>ld` | Diagnostic float (at cursor) |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open Neogit (file explorer with inline diffs, press `<tab>` to expand files) |
| `<leader>gp` | Git pull |
| `<leader>gs` | Git status picker |
| `<leader>gb` | Git branches picker |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log (line) |
| `<leader>gf` | Git log (file) |
| `<leader>gd` | Git diff hunks picker |
| `<leader>gS` | Git stash picker |
| `<leader>gB` | Git blame |
| `<leader>go` | Open in browser (GitHub) |
| `<leader>ghi` | GitHub issues |
| `<leader>ghp` | GitHub PRs |

### Git Hunks

| Keymap | Action |
|--------|--------|
| `]h` / `[h` | Next/previous hunk |
| `<leader>hh` | Preview hunk |
| `<leader>hs` | Stage hunk (normal); in visual: stage selection (buffer-local via gitsigns) |
| `<leader>hr` | Reset hunk (normal); in visual: reset selection (buffer-local via gitsigns) |
| `<leader>hu` | Undo stage hunk (buffer-local via gitsigns) |
| `ih` | Select hunk (text object) |
| `<leader>di` | Preview inline diff |
| `<leader>dw` | Toggle word-level diff highlighting |

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
| `ar`/`ir` | Outer/inner return statement |
| `an`/`in` | Incremental selection (expand/shrink, built-in v0.12+) |

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

### Diff (CodeDiff)

| Keymap | Action |
|--------|--------|
| `<leader>dd` | Diff all changes (explorer view) |
| `<leader>dmo` | Diff all vs origin/main (or origin/master) |
| `<leader>dml` | Diff all vs local main (or master) |
| `<leader>d1` | Diff vs HEAD~1 |
| `<leader>d2` | Diff vs HEAD~2 |
| `<leader>d3` | Diff vs HEAD~3 |
| `<leader>d4` | Diff vs HEAD~4 |
| `<leader>d5` | Diff vs HEAD~5 |
| `<leader>dw` | Toggle word-level diff highlighting |
| `<leader>di` | Preview inline diff (auto-clears on cursor move) |
| `]h` / `[h` | Next/previous hunk |
| `ih` | Select hunk (text object, works with operators like `d`, `y`, `c`) |

**In CodeDiff view:**

| Keymap | Action |
|--------|--------|
| `q` | Close diff view |
| `]c` / `[c` | Next/previous change |
| `]f` / `[f` | Next/previous file (explorer mode) |
| `do` | Get change from other buffer |
| `dp` | Put change to other buffer |
| `<leader>b` | Toggle explorer panel |

**Git Integration:**

CodeDiff is also configured as the default `git difftool` and `git mergetool`:

```bash
git difftool           # Compare files using CodeDiff
git mergetool          # Resolve merge conflicts using CodeDiff
```

### Toggles

| Keymap | Action |
|--------|--------|
| `<leader>tn` | Toggle relative line numbers |
| `<leader>ts` | Toggle spell checking (Vim built-in) |
| `<leader>tw` | Toggle whitespace display (cycles: default → all → off) |
| `<leader>tW` | Toggle wrap (buffer) |
| `<leader>tc` | Toggle completion menu (blink/off) |
| `<leader>td` | Toggle diagnostic virtual text (ghost text) |
| `<leader>tgc` | Toggle Copilot ghost text |
| `<leader>tgn` | Toggle NES (Next Edit Suggestions) |
| `<leader>th` | Toggle Harper grammar checker |
| `<leader>tl` | Toggle LSP globally |
| `<leader>tm` | Toggle Markdown render |
| `<leader>tv` | Toggle CSV view |

### Completion (blink.cmp)

Blink.cmp provides the completion menu with sources from LSP, Copilot, snippets, buffer text, and file paths. All sources are combined and ranked by relevance. The source name (LSP, copilot, Buffer, etc.) is shown next to each item.

| Keymap | Action |
|--------|--------|
| `<Enter>` | Accept completion |
| `<Tab>` | Next item (when menu visible) |
| `<S-Tab>` | Previous item (when menu visible) |
| `<C-j>` | Next item |
| `<C-k>` | Previous item |
| `<C-e>` | Cancel completion |
| `<C-Space>` | Trigger completion manually |

**Toggles:**
| Keymap | Action |
|--------|--------|
| `<leader>tc` | Toggle completion menu (blink/off) |
| `<leader>tgc` | Toggle Copilot ghost text (inline suggestions) |
| `<leader>tgn` | Toggle NES (Next Edit Suggestions) |

**Notes:**
- Copilot suggestions appear in the completion menu when `copilot-language-server` is installed
- Copilot ghost text (inline suggestions) is off by default, toggle with `<leader>tgc`
- NES (predictive multi-location edits) is provided by sidekick.nvim

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
| `<C-b>` (visual) | Add markdown bold (`**text**`) |
| `<C-i>` (visual) | Add markdown italic (`*text*`) |

**Surrounding characters:**
- `(`, `)`, `[`, `]`, `{`, `}`, `<`, `>` - Bracket pairs (opening adds space, closing doesn't)
- `'`, `"`, `` ` `` - Quote characters
- `f` - Function call (prompts for function name when adding)
- `t` - HTML/XML tag (prompts for tag name when adding)
- `B` - Markdown bold (`**text**`)
- `I` - Markdown italic (`*text*`)
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
| `<leader>tgn` | Toggle NES (Next Edit Suggestions) |

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

### Clipboard / Registers

Yanks (`y`) go to the system clipboard, while deletes (`d`, `x`, `c`) stay in internal registers.

| Keymap | Action |
|--------|--------|
| `y` | Yank to system clipboard |
| `Y` | Yank to end of line to system clipboard |
| `p` | Paste from internal register (last delete/yank) |
| `"+p` | Paste from system clipboard |

### Misc

| Keymap | Action |
|--------|--------|
| `<Esc>` | Clear search highlights |
| `<leader>?` | Buffer local keymaps |

## Zsh Keybindings

| Keymap | Action |
|--------|--------|
| `Ctrl+e` | Edit current command in `$EDITOR` |
| `Up/Down` | Smart history search (type partial command first) |
| `Delete` | Forward delete character |

## Ghostty Keybindings

| Keymap | Action |
|--------|--------|
| `` Cmd+` `` | Toggle quick terminal (dropdown from top) |

## Usage

This repository is managed as my personal configuration. If you're me and setting up a new machine, you know what to do. If you're not me, you probably want to look elsewhere.

