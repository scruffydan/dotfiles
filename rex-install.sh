#!/usr/bin/env sh
# Include ~/dotfiles/rex/init.lua from Rex's local config.
# Usage: ./rex-install.sh
set -eu

if [ "$#" -ne 0 ]; then
  printf 'Usage: %s\n' "$0" >&2
  exit 1
fi

shared_config="$HOME/dotfiles/rex/init.lua"
config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/rex"
target="$config_dir/init.lua"
include='dofile(os.getenv("HOME") .. "/dotfiles/rex/init.lua")'

if [ ! -f "$shared_config" ]; then
  printf 'Rex config is missing: %s\n' "$shared_config" >&2
  exit 1
fi

if [ -L "$target" ] || { [ -e "$target" ] && [ ! -f "$target" ]; }; then
  printf 'Rex config must be a separate regular file: %s\n' "$target" >&2
  exit 1
fi
mkdir -p "$config_dir"
config_dir_real=$(CDPATH= cd -- "$config_dir" && pwd -P)
shared_dir_real=$(CDPATH= cd -- "$HOME/dotfiles/rex" && pwd -P)
if [ "$config_dir_real" = "$shared_dir_real" ]; then
  printf 'Rex config must be a separate regular file: %s\n' "$target" >&2
  exit 1
fi
if [ -f "$target" ] && grep -Fqx "$include" "$target"; then
  exit 0
fi

staged=$(mktemp "$config_dir/.init.lua.XXXXXX")
trap 'rm -f "$staged"' EXIT
trap 'exit 1' HUP INT TERM

if [ -f "$target" ]; then
  cp -p "$target" "$staged"
fi
{
  printf '%s\n' "$include"
  if [ -f "$target" ]; then
    printf '\n'
    cat "$target"
  fi
} > "$staged"
mv -f "$staged" "$target"
