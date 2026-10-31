#!/usr/bin/env sh
# Install the SubMonokai theme for Ghostty. Usage: ./install-ghostty.sh
set -eu

theme_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
theme_source="$theme_dir/SubMonokai.ghostty"
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/ghostty"
theme_target="$config_dir/themes/SubMonokai"

mkdir -p "$config_dir/themes"
if [ -L "$theme_target" ] && [ "$(readlink "$theme_target")" = "$theme_source" ]; then
  : # Already installed from this checkout.
elif [ -e "$theme_target" ] || [ -L "$theme_target" ]; then
  printf 'Theme already exists at %s; move it aside before installing.\n' "$theme_target" >&2
  exit 1
else
  ln -s "$theme_source" "$theme_target"
fi

printf 'SubMonokai installed. Select it with: theme = SubMonokai\n'
