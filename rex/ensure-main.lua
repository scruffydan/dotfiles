local function ensure_main(created_id)
  local sessions = rex.call("session.list").sessions
  local first = sessions[1]
  if not first or first.label == "main" then return end
  -- Opening a later session should respect a name the user has since chosen.
  if created_id and first.session_id ~= created_id then return end

  -- Keep an existing main when Rex restores sessions in a different order.
  for _, session in ipairs(sessions) do
    if session.label == "main" then
      rex.call("session.attach", { session_id = session.session_id })
      rex.call("session.move", { session_id = session.session_id, before_session_id = first.session_id })
      return
    end
  end

  rex.call("session.attach", { session_id = first.session_id })
  rex.call("session.set_label", { session_id = first.session_id, label = "main" })
end

if rex.args and rex.args.watch then
  rex.on("session_created", function(_, event)
    ensure_main(event.session.session_id)
  end)
end
ensure_main()
