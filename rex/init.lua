local function bind(key, ...)
  rex.bind("ctrl+a>" .. key, ...)
end

-- Forward the prefix to remote tmux or another terminal program.
bind("ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Tabs correspond to tmux windows.
bind("c", "client.tab.new")
bind("n", "client.tab.next")
bind("shift+n", "client.tab.previous")
bind(",", "client.tab.rename")

-- Leave bare Ctrl-h/j/k/l available to terminal applications and SSH.
bind("\\", "pane.split", { direction = "right" })
bind("shift+\\", "pane.split", { direction = "right" })
bind("-", "pane.split", { direction = "down" })
bind("h", "pane.focus.left")
bind("j", "pane.focus.down")
bind("k", "pane.focus.up")
bind("l", "pane.focus.right")
bind("shift+h", "pane.resize", { direction = "left" })
bind("shift+j", "pane.resize", { direction = "down" })
bind("shift+k", "pane.resize", { direction = "up" })
bind("shift+l", "pane.resize", { direction = "right" })
bind("z", "pane.zoom")

bind(".", "session.rename")
bind("ctrl+s", "session.switch")
bind("ctrl+q", "client.palette.toggle")
bind("escape", "pane.copy_mode.enter")

-- Open a floating terminal with backtick or tilde.
bind("`", "pane.new_floating")
bind("shift+`", "pane.new_floating")
