# Dotfiles Agent Guide

This is a personal project maintained for the repository owner's own use.

This repository contains personal configuration files (dotfiles) for zsh, tmux, neovim, git, and ghostty terminal.

## Testing Changes

### Zsh
```bash
source ~/.zshrc       # Reload current shell
zsh                   # Start new shell to test
```

### Neovim
```bash
nvim                  # Changes reload on restart
:Lazy reload <plugin> # Reload specific plugin without restart
:checkhealth          # Verify configuration health
```

### Tmux
```bash
# Inside tmux, prefix is Ctrl-a
<C-a> r               # Reload tmux config (bound in tmux.conf)
```

## Platform Considerations

This config supports macOS, Linux, and FreeBSD:

- **macOS-specific**: Check `[[ $(uname) == Darwin ]]` or `vim.fn.has("macunix")`
- **FreeBSD**: Mason LSP doesn't work; treesitter needs `pkg install tree-sitter`
- **Tmux clipboard**: macOS uses `pbcopy`, loaded via `tmux/tmux.mac.conf`
- **Neovim config location**: Lives in `~/dotfiles/nvim/`, not `~/.config/nvim/`

## Code Style Guidelines

### Lua (Neovim)

- **Indentation**: 2 spaces
- **Quotes**: Double quotes for strings
- **Plugin specs**: One file per plugin in `nvim/lua/plugins/`
- **Return format**: Each plugin file returns a table or list of tables
- **Lazy loading**: Use `event`, `cmd`, `ft`, or `keys` for lazy loading
- **Keymaps**: Include `desc` for which-key integration
- **Borders**: Use `"rounded"` for UI consistency

```lua
-- Good: Plugin file structure
return {
  "author/plugin-name",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "dependency/plugin" },
  opts = {
    setting = true,
  },
  keys = {
    { "<leader>xx", function() ... end, desc = "Description" },
  },
}
```

### Zsh

- **Indentation**: 2 spaces (in functions)
- **Quotes**: Double quotes for variables, single for literals
- **Comments**: Use `#` with space, section headers use `##`
- **Functions**: Use `name() { }` syntax
- **Conditionals**: Use `[[ ]]` over `[ ]`

```zsh
# Good: Function with description
# Description of what this does
my_function() {
  local var="$1"
  [[ -n "$var" ]] && echo "$var"
}
```

### Tmux

- **Variables**: Define color palette at top of file
- **Comments**: Use `#` with description
- **Key bindings**: Group by function (sessions, windows, panes)
- **Repeatable bindings**: Use `bind -r` for navigation/resize

### Shell Scripts (install scripts)

- **Shebang**: `#!/usr/bin/env sh` for portability
- **Header comment**: Describe purpose and usage
- **Idempotent**: Scripts should be safe to run multiple times

## Color Scheme

Uses SubMonokai theme across all tools. Key colors defined in:
- Neovim: https://github.com/scruffydan/submonokai-nvim
- Tmux: Palette variables at top of tmux.conf
- Ghostty/Rex/iTerm2: `submonokai/`, a Git subtree of https://github.com/scruffydan/submonokai (`SubMonokai.ghostty` and `Submonokai.itermcolors`)

## Important Notes

1. **zsh-syntax-highlighting/** is a git submodule - do not modify directly
2. **SubMonokai.terminal** is for macOS Terminal.app export - rarely used
3. Most install scripts **append** to existing files - run only once per machine. `ghostty-install.sh` is safe to rerun.
4. When modifying terminal colors, update tmux.conf and the shared SubMonokai theme repo to keep them in sync
5. Edit SubMonokai upstream, not inside the subtree. The SubMonokai workflow syncs it hourly; `sh scripts/sync-submonokai.sh` refreshes it locally. Never squash away Git subtree metadata commits when merging a subtree import/update PR.
