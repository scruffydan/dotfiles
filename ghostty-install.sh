#!/usr/bin/env sh
#
# Ghostty terminal configuration installer
# Usage: ./ghostty-install.sh [path/to/submonokai]
# Installs the shared theme and includes ~/dotfiles/ghostty in the local config.
#
set -eu

theme_repo="${1:-"$HOME/Code/submonokai"}"
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/ghostty"

if [ ! -f "$theme_repo/install-ghostty.sh" ]; then
  printf 'Clone https://github.com/scruffydan/submonokai into %s first, or pass its path.\n' "$theme_repo" >&2
  exit 1
fi

sh "$theme_repo/install-ghostty.sh"
touch "$config_dir/config"
if ! grep -Fqx 'config-file = ~/dotfiles/ghostty' "$config_dir/config"; then
  printf '\n# Source my default config\nconfig-file = ~/dotfiles/ghostty\n' >> "$config_dir/config"
fi
