#!/usr/bin/env sh

# Show names in fzf, but keep selection data out of shell source and target by ID.
session=$(
  tmux list-sessions -F '#{session_id} #{session_name}' |
    grep -Fxv -- "$(tmux display-message -p '#{session_id} #{session_name}')" |
    fzf --reverse --no-multi --delimiter=' ' --with-nth=2..
) || exit 0

[ -n "$session" ] || exit 0
session=${session%% *}
tmux move-window -t "$session:" && tmux switch-client -t "$session"
