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

- **make** (or cmake/gmake) - Required for building telescope-fzf-native plugin
- **ripgrep (rg)** - Required for telescope live grep functionality
- **C compiler** (gcc/clang) - Required for treesitter parser compilation (typically pre-installed on macOS and FreeBSD)
- **tree-sitter-cli** (0.25.0 or later) - Required for nvim-treesitter main branch
  - macOS: `brew install tree-sitter-cli`
  - FreeBSD: `pkg install tree-sitter-cli`
  - Ubuntu/Debian: Download binary from [GitHub releases](https://github.com/tree-sitter/tree-sitter/releases) or `cargo install tree-sitter-cli`
- **git** - Required for lazy.nvim plugin manager and gitsigns
- **awk** - Used in tmux status bar (typically pre-installed on macOS, Linux, and FreeBSD)

## Usage

This repository is managed as my personal configuration. If you're me and setting up a new machine, you know what to do. If you're not me, you probably want to look elsewhere.

