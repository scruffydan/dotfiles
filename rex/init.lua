local function bind(key, ...)
  rex.bind("ctrl+a>" .. key, ...)
end

-- Forward the prefix to remote tmux or another terminal program.
bind("ctrl+a", "pane.send_key", { key = "ctrl+a" })
bind("r", "client.config.reload")

-- Tabs correspond to tmux windows.
bind("c", "client.tab.new")
bind("n", "client.tab.next")
bind("shift+n", "client.tab.previous")
bind(",", "client.tab.rename")
-- Tabs count from 1, matching tmux's base-index 1.
for index = 1, 9 do
  bind(tostring(index), "client.tab.goto", { index = index })
end

-- Leave bare Ctrl-h/j/k/l available to terminal applications and SSH.
bind("\\", "pane.split", { direction = "right" })
bind("shift+\\", "pane.split", { direction = "right" })
bind("-", "pane.split", { direction = "down" })
bind("h", "pane.focus.left")
bind("j", "pane.focus.down")
bind("k", "pane.focus.up")
bind("l", "pane.focus.right")
bind("z", "pane.zoom")

-- Resize once on entry, then keep resizing without repeating the prefix.
-- Escape exits the mode and restores normal terminal input.
rex.mode("resize", { exclusive = true })
for _, binding in ipairs({
  { "h", "left" },
  { "j", "down" },
  { "k", "up" },
  { "l", "right" },
}) do
  local key, direction = binding[1], binding[2]
  bind("ctrl+" .. key, "pane.move." .. direction)
  local action = "dotfiles_resize_" .. direction
  rex.action({
    name = action,
    title = "Start pane resize " .. direction,
    run = function()
      rex.client.queue("pane.resize", { direction = direction })
      rex.client.queue("client.mode.enter", { name = "resize" })
    end,
  })
  bind("shift+" .. key, action)
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = direction })
end

bind(".", "session.rename")
bind("ctrl+s", "session.switch")
bind("ctrl+q", "client.palette.toggle")
bind("escape", "pane.copy_mode.enter")

-- Backtick opens a floating pane, then hides and shows it. Tilde floats the
-- focused pane.
rex.action({
  name = "dotfiles_toggle_floating",
  title = "Toggle floating panes",
  run = function(ctx)
    local view = rex.call("session.view", { session_id = ctx.session_id })
    local layers = {}
    for _, window in ipairs(view.windows) do
      if window.window_id == view.active_window_id then layers = window.layers end
    end
    local function set_state(layer, state, focus)
      rex.call("session.set_layer_state", {
        session_id = ctx.session_id, layer_id = layer.layer_id, state = state, focus = focus,
      })
    end

    -- Layers run back to front, and the first one is the tiled layout.
    local visible = false
    for i = 2, #layers do
      visible = visible or layers[i].state ~= "minimized"
    end
    if #layers < 2 then
      rex.client.queue("pane.new_floating")
    elseif visible then
      for i = 2, #layers do set_state(layers[i], "minimized") end
    else
      set_state(layers[#layers], "normal", true)
    end
  end,
})
bind("`", "dotfiles_toggle_floating")
bind("shift+`", "pane.float")

local main_script = os.getenv("HOME") .. "/dotfiles/rex/ensure-main.lua"
rex.action({
  name = "dotfiles_ensure_main",
  title = "Ensure main is the first session",
  run = function() dofile(main_script) end,
})
-- Finder may launch Rex without its bundled CLI on PATH.
local bundled_cli_dir = "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS"
assert(rex.exec.start({ "rex", "--autostart=false", "do", "--all", main_script, "watch=true" }, {
  detach = true,
  env = { PATH = (os.getenv("PATH") or "/usr/bin:/bin") .. ":" .. bundled_cli_dir },
}))
