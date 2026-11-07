#!/usr/bin/env sh
# macOS-only Zen picture-in-picture sync setup.
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

pref_name='services.sync.prefs.sync.media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled'
pref="user_pref(\"$pref_name\", true);"
profiles=0

for profile do
  [ -d "$profile" ] || {
    printf 'Zen profile directory not found: %s\n' "$profile" >&2
    exit 1
  }
  user_js="$profile/user.js"
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
  profiles=$((profiles + 1))
done

printf 'Enabled PiP preference syncing in %s profile(s). Reopen Zen to apply.\n' "$profiles"
