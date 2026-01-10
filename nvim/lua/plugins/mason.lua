-- Prepend Mason bin to PATH immediately during require()
-- This runs before lazy.nvim processes plugin specs, so cond checks can find Mason tools
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Packages to auto-install via Mason
local ensure_installed = {
  -- LSP servers
  "lua-language-server",
  "marksman",
  "harper-ls",
  -- Tree-sitter CLI
  "tree-sitter-cli",
}

-- Check if we're on a supported platform for Mason binaries
local function is_supported_platform()
  local uname = vim.loop.os_uname()
  local sysname = uname.sysname:lower()
  -- Mason provides binaries for Linux, macOS, and Windows
  return sysname == "linux" or sysname == "darwin" or sysname:match("windows")
end

if not is_supported_platform() then
  -- Return empty config on unsupported platforms (e.g., FreeBSD)
  return {}
end

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    priority = 100, -- Load before plugins that depend on Mason-installed tools
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })

      -- Auto-install tools
      local registry = require("mason-registry")
      local function install_package(pkg_name)
        local ok, pkg = pcall(registry.get_package, pkg_name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end

      -- Ensure registry is up to date before checking packages
      registry.refresh(function()
        for _, pkg_name in ipairs(ensure_installed) do
          install_package(pkg_name)
        end
      end)
    end,
  },
}
