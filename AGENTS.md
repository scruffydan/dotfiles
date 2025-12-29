# Dotfiles Agent Guide

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
- Tmux/Ghostty: Palette variables at top of config files

## Important Notes

1. **zsh-syntax-highlighting/** is a git submodule - do not modify directly
2. **SubMonokai.terminal** is for macOS Terminal.app export - rarely used
3. Install scripts **append** to existing files - run only once per machine
4. When modifying colors, update both tmux.conf and ghostty to keep them in sync
