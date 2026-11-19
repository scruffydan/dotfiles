local function find_or_create_main(sessions)
  for _, session in ipairs(sessions) do
    if session.label == "main" then return session.session_id end
  end

  local shell = rex.layout.block({
    flavor = "com.superlogical.terminal.shell",
    options = { cwd = os.getenv("HOME") },
  })
  return rex.call("session.create", {
    label = "main",
    initial_windows = {{ layout = shell }},
  }).session_id
end

rex.action({
  name = "dotfiles_ensure_main",
  title = "Ensure main is the first session",
  run = function()
    local sessions = rex.call("session.list").sessions
    if sessions[1] and sessions[1].label == "main" then return end

    local main_id = find_or_create_main(sessions)
    -- The Mac app can create a session while the new shell starts.
    local first = rex.call("session.list").sessions[1]
    if first and first.session_id ~= main_id then
      rex.call("session.attach", { session_id = main_id })
      rex.call("session.move", { session_id = main_id, before_session_id = first.session_id })
    end
  end,
})

-- Config loading has no session context. Invoke the action through the CLI.
-- Finder may launch Rex without its bundled CLI on PATH.
local bundled_cli_dir = "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS"
assert(rex.exec.start({ "rex", "--autostart=false", "do", "dotfiles_ensure_main" }, {
  detach = true,
  env = { PATH = (os.getenv("PATH") or "/usr/bin:/bin") .. ":" .. bundled_cli_dir },
}))
