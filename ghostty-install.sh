#!/usr/bin/env sh
#
# Ghostty terminal configuration installer
# Usage: ./ghostty-install.sh
# Includes ~/dotfiles/ghostty, which loads the bundled SubMonokai theme.
#
set -eu

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/ghostty"

if [ "$#" -ne 0 ]; then
  printf 'Usage: %s (the SubMonokai theme is bundled in dotfiles)\n' "$0" >&2
  exit 1
fi

if [ ! -f "$dotfiles_dir/submonokai/SubMonokai.ghostty" ]; then
  printf 'Bundled SubMonokai theme is missing; pull the complete dotfiles repository.\n' >&2
  exit 1
fi

mkdir -p "$config_dir"
touch "$config_dir/config"
if ! grep -Fqx 'config-file = ~/dotfiles/ghostty' "$config_dir/config"; then
  printf '\n# Source my default config\nconfig-file = ~/dotfiles/ghostty\n' >> "$config_dir/config"
fi
