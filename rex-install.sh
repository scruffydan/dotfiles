#!/usr/bin/env sh
# Link the versioned Rex Lua configuration into Rex's config directory.
# Usage: ./rex-install.sh
set -eu

if [ "$#" -ne 0 ]; then
  printf 'Usage: %s\n' "$0" >&2
  exit 1
fi

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
source="$dotfiles_dir/rex/init.lua"
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/rex"
target="$config_dir/init.lua"

if [ ! -f "$source" ]; then
  printf 'Rex config is missing: %s\n' "$source" >&2
  exit 1
fi

mkdir -p "$config_dir"
if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
  exit 0
fi
if [ -e "$target" ] || [ -L "$target" ]; then
  printf 'Rex config already exists at %s. Move it aside or merge the dotfiles bindings into it.\n' "$target" >&2
  exit 1
fi

ln -s "$source" "$target"
