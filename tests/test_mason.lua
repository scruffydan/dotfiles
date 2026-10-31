-- Run from the repository root: luajit tests/test_mason.lua (or lua).
-- All Mason and Neovim APIs are stubbed; no user config or installers are loaded.
local unpack = table.unpack or unpack
local base_packages = {
  "lua-language-server",
  "marksman",
  "harper-ls",
  "terraform-ls",
  "tree-sitter-cli",
}

local function check(options)
  local notifications, scheduled, pending, requested = {}, {}, {}, {}
  local expected_packages = { unpack(base_packages) }
  if options.npm then
    table.insert(expected_packages, "bash-language-server")
    table.insert(expected_packages, "shellcheck")
  end

  _G.vim = {
    env = { PATH = "/usr/bin" },
    fn = { stdpath = function() return "/isolated-data" end },
    log = { levels = { INFO = 2, ERROR = 4 } },
    notify = function(message, level)
      notifications[#notifications + 1] = { message, level }
    end,
    schedule = function(callback) scheduled[#scheduled + 1] = callback end,
    list_extend = function(list, extra)
      for _, item in ipairs(extra) do
        table.insert(list, item)
      end
    end,
  }
  package.loaded.util = {
    is_mason_supported = not options.unsupported,
    has_npm = options.npm,
  }
  local setup_called = false
  package.loaded.mason = { setup = function() setup_called = true end }
  package.loaded["mason-registry"] = {
    refresh = function(callback) callback() end,
    get_package = function(name)
      requested[#requested + 1] = name
      if name == options.unavailable then
        error("Package unavailable")
      end
      return {
        is_installed = function() return options.installed end,
        install = function(_, _, callback)
          local listeners = {}
          local handle = {
            once = function(self, event, listener)
              listeners[event] = listener
              return self
            end,
          }
          local function finish()
            -- Mason closes the handle before reporting either result.
            if listeners.closed then
              listeners.closed()
              listeners.closed = nil
            end
            if callback and not options.close_only then
              callback(options.success, options.success and {} or "Controlled failure")
            end
          end
          if options.immediate then
            finish() -- Results may arrive before install() returns.
          else
            pending[#pending + 1] = finish
          end
          return handle
        end,
      }
    end,
  }

  local spec = dofile("nvim/lua/plugins/mason.lua")
  if options.unsupported then
    assert(next(spec) == nil, "Unsupported platforms must skip Mason")
    assert(not setup_called and #requested == 0)
    return
  end
  spec.config(nil, {})
  assert(setup_called)
  assert(table.concat(requested, ",") == table.concat(expected_packages, ","), "Package list changed")
  local count = options.installed and 0 or #expected_packages - (options.unavailable and 1 or 0)
  assert(#notifications == count, "Only installing notifications should run before scheduling")
  for _, finish in ipairs(pending) do
    finish()
  end
  for _, callback in ipairs(scheduled) do
    callback()
  end

  local expected = {}
  for _, name in ipairs(expected_packages) do
    if not options.installed and name ~= options.unavailable then
      expected["Mason: installing " .. name] = vim.log.levels.INFO
      if not options.close_only then
        local suffix = options.success and " installed" or " failed to install"
        expected["Mason: " .. name .. suffix] = options.success and vim.log.levels.INFO or vim.log.levels.ERROR
      end
    end
  end
  for _, notification in ipairs(notifications) do
    local message, level = unpack(notification)
    assert(expected[message] == level, "Unexpected notification: " .. message .. " (level " .. level .. ")")
    expected[message] = nil -- Duplicate results must fail too.
  end
  assert(next(expected) == nil, "Missing installation notification")
end

local failures, cases = {}, 0
local function test(name, options)
  cases = cases + 1
  local ok, err = pcall(check, options)
  if not ok then
    failures[#failures + 1] = name .. ": " .. tostring(err)
  end
end

for _, immediate in ipairs({ false, true }) do
  local timing = immediate and "immediate" or "delayed"
  test(timing .. " success", { immediate = immediate, success = true })
  test(timing .. " failure", { immediate = immediate, success = false })
  test(timing .. " close without result", { immediate = immediate, close_only = true })
end
test("npm packages", { npm = true, success = true })
test("already installed", { installed = true })
test("unavailable package", { unavailable = "marksman", success = true })
test("unsupported platform", { unsupported = true })

assert(#failures == 0, table.concat(failures, "\n"))
print("Mason: " .. cases .. " isolated checks passed")
