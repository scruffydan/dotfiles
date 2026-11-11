#!/usr/bin/env sh
# macOS-only Zen shortcut, workspace container, and picture-in-picture sync setup.
# Usage: ./zen-macos-install.sh [profile-directory ...]
# Quit Zen before running, then reopen it afterward.
set -eu

if [ "$(uname -s)" != 'Darwin' ]; then
  printf 'This installer supports macOS only.\n' >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  set -- "$HOME/Library/Application Support/zen/Profiles/"*/
fi

profiles=0
custom_keys_tmp=''
trap '[ -z "$custom_keys_tmp" ] || rm -f "$custom_keys_tmp"' 0

for profile do
  [ -d "$profile" ] || {
    printf 'Zen profile directory not found: %s\n' "$profile" >&2
    exit 1
  }
  custom_keys="$profile/customKeys.json"
  custom_keys_tmp=$(mktemp "$profile/.customKeys.XXXXXX")
  # Use XML while editing: plutil treats an empty JSON object as OpenStep.
  if [ -f "$custom_keys" ]; then
    /usr/bin/plutil -convert xml1 -o "$custom_keys_tmp" "$custom_keys"
  else
    /usr/bin/plutil -create xml1 "$custom_keys_tmp"
  fi
  # Free Command-Shift-N from New Blank Window, then use it for private windows.
  # Update only these bindings so other custom shortcuts are preserved.
  /usr/bin/plutil -replace zen-new-unsynced-window -json '{}' "$custom_keys_tmp"
  /usr/bin/plutil -replace key_privatebrowsing \
    -json '{"modifiers":"accel,shift","key":"N"}' "$custom_keys_tmp"
  /usr/bin/plutil -convert json "$custom_keys_tmp"
  mv "$custom_keys_tmp" "$custom_keys"
  custom_keys_tmp=''

  user_js="$profile/user.js"
  for pref_name in \
    'zen.workspaces.force-container-workspace' \
    'services.sync.prefs.sync.zen.workspaces.force-container-workspace' \
    'services.sync.prefs.sync.media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled'
  do
    pref="user_pref(\"$pref_name\", true);"
    last_pref=''
    if [ -f "$user_js" ]; then
      last_pref=$(awk -v key="\"$pref_name\"" '
        /^[[:space:]]*user_pref[[:space:]]*\(/ && index($0, key) { last = $0 }
        END { print last }
      ' "$user_js")
    fi
    if [ "$last_pref" != "$pref" ]; then
      printf '\n%s\n' "$pref" >> "$user_js"
    fi
  done
  profiles=$((profiles + 1))
done

printf 'Configured private-window shortcuts, workspace containers, and preference syncing in %s profile(s). Reopen Zen to apply.\n' "$profiles"
