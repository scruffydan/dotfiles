#!/usr/bin/env sh
# Refresh the bundled theme repo. Usage: sh scripts/sync-submonokai.sh [repository [ref]]
# Git subtree commits the update locally; this script never pushes it.
set -eu

if [ "$#" -gt 2 ]; then
  printf 'Usage: %s [repository [ref]]\n' "$0" >&2
  exit 1
fi

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
cd "$dotfiles_dir"

if [ -n "$(git status --porcelain)" ]; then
  printf 'Commit or move aside local changes before syncing SubMonokai.\n' >&2
  exit 1
fi

git subtree pull --prefix=submonokai \
  "${1:-https://github.com/scruffydan/submonokai.git}" "${2:-master}" --squash
