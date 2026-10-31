# Shared terminal theme

## Goal

Extract the Ghostty colours from the personal dotfiles without changing its
appearance, make the file importable by Rex, and align the iTerm2 export.

## Design

Keep `SubMonokai.ghostty` beside the existing app exports. A theme in dotfiles
would be harder to discover and reuse; duplicating it there would create drift.
The shared theme contains only colour settings. Fonts and terminal behaviour
stay in the dotfiles config, which selects `theme = SubMonokai`.

Pin ANSI 15 to `#EAEAEA`, the Ghostty 1.4.0 default previously inherited by the
dotfiles. All other existing Ghostty colours remain unchanged. Update only ANSI
15 in the iTerm2 export; its other equivalent colours already match.

`install-ghostty.sh` symlinks the theme into the XDG Ghostty themes directory.
It supports repeated runs and fails without replacing a conflicting file or
symlink. The dotfiles installer invokes this script using a local checkout,
defaulting to `~/Code/submonokai`, with an optional path argument. There are no
network requests during installation.

Rex imports the same file through its command palette. Imports must be repeated
after edits; this does not configure Rex through its Lua server config.

## Verification

Compare resolved Ghostty settings before and after extraction, excluding only
the theme selector. Validate the theme, check shell syntax, exercise repeated
installation and conflict handling in temporary directories, and compare all
equivalent iTerm2 colours with the shared theme. App rendering and Rex import
require separate live verification.
