local function ensure_main(sessions, created_id)
  local first = sessions[1]
  if not first or first.label == "main" then return end
  -- Opening a later session should respect a name the user has since chosen.
  if created_id and first.session_id ~= created_id then return end

  -- Keep an existing main when Rex restores sessions in a different order.
  for _, session in ipairs(sessions) do
    if session.label == "main" then
      rex.call("session.move", { session_id = session.session_id, before_session_id = first.session_id })
      return
    end
  end

  rex.call("session.set_label", { session_id = first.session_id, label = "main" })
end

local sessions = rex.call("session.attach_all", { event_scope = "all" }).sessions
if rex.args and rex.args.watch then
  -- Rex lists clients in connection order. The oldest active watcher owns the job.
  local prefix = "dotfiles-main:"
  local token = os.tmpname()
  os.remove(token)
  local label = prefix .. token:match("[^/]+$")
  local function owns_watch()
    for _, client in ipairs(rex.call("client.list").clients) do
      local name = client.info and client.info.label
      if client.connection_state == "connected" and name and name:sub(1, #prefix) == prefix then
        return name == label
      end
    end
    return false
  end

  rex.call("client.set_label", { label = label })
  if not owns_watch() then return end
  -- Resolve simultaneous starts after the other client announces itself.
  rex.on("client_changed", function()
    if not owns_watch() then rex.stop() end
  end)
  rex.on("session_created", function(_, event)
    ensure_main(rex.call("session.list").sessions, event.session.session_id)
  end)
end
ensure_main(sessions)
