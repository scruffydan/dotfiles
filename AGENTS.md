# Dotfiles Agent Guide

Personal dotfiles for the owner's own use: zsh, tmux, Neovim, Git, and Ghostty.
Prefer simple, maintainable changes.

## Project conventions

- Support macOS, Linux, and FreeBSD; guard platform-specific settings.
- Neovim lives in `~/dotfiles/nvim/`. Use 2-space indentation, double quotes,
  one lazy-loaded plugin spec per file in `nvim/lua/plugins/`, keymap `desc`,
  and rounded UI borders.
- Zsh: 2-space indentation, quote variables, use `name() { }` and `[[ ]]`.
- Tmux: palette and appearance live in the upstream `SubMonokai.tmux.conf` export;
  keep bindings grouped by function and use `bind -r` for navigation.
  macOS clipboard settings live in `tmux/tmux.mac.conf`.
- Install scripts use `#!/usr/bin/env sh`; make new scripts idempotent.
  Existing installers mostly append to files; `ghostty-install.sh` is safe to rerun.
- FreeBSD: Mason LSP is unsupported; treesitter needs `pkg install tree-sitter`.

## Shared themes and dependencies

- Do not edit the `zsh/zsh-syntax-highlighting/` submodule directly.
- Edit SubMonokai upstream at https://github.com/scruffydan/submonokai,
  not in the `submonokai/` subtree. Sync runs hourly, or manually with
  `sh scripts/sync-submonokai.sh`. Preserve subtree metadata: do not squash or
  rebase subtree import/update PRs.
- Ghostty and tmux source their bundled SubMonokai exports directly. Keep the
  palette at the top of the upstream tmux export. tmux 3.8+ uses native dark-theme
  slots; retain the ANSI/RGB fallback for older supported versions and the custom
  status and pane styles shared by both paths.
  Neovim's theme is https://github.com/scruffydan/submonokai-nvim.

## Verification

- Zsh: start `zsh` or reload with `source ~/.zshrc`.
- Neovim: restart and run `:checkhealth` when relevant.
- Tmux: reload with `Ctrl-a r`.
