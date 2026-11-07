#!/usr/bin/env sh
# Quit Zen before running. Optional arguments are explicit Zen profile directories.
set -eu

if [ "$#" -eq 0 ]; then
  case "$(uname -s)" in
    Darwin) set -- "$HOME/Library/Application Support/zen/Profiles/"*/ ;;
    *)
      printf 'Pass your Zen profile directory from about:support as an argument.\n' >&2
      exit 1
      ;;
  esac
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
