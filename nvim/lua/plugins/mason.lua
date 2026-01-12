-- Mason package manager for LSP servers and tools
-- Mason only handles installation; LSP config is in nvim/lsp/*.lua

-- Prepend Mason bin to PATH at require time (before lazy.nvim processes cond checks)
-- This allows other plugins to find Mason-installed tools like tree-sitter-cli
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Check if we're on a supported platform for Mason binaries
local function is_supported_platform()
  local sysname = vim.uv.os_uname().sysname:lower()
  return sysname == "linux" or sysname == "darwin" or sysname:match("windows")
end

-- Skip Mason entirely on unsupported platforms (e.g., FreeBSD)
if not is_supported_platform() then
  return {}
end

return {
  "mason-org/mason.nvim",
  lazy = false,
  opts = {
    ui = { border = "rounded" },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Auto-install packages if not already installed
    local ensure_installed = {
      "lua-language-server",
      "marksman",
      "harper-ls",
      "bash-language-server",
      "shellcheck", -- Used by bash-language-server for diagnostics
      "tree-sitter-cli",
    }

    local registry = require("mason-registry")
    registry.refresh(function()
      for _, name in ipairs(ensure_installed) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end,
}
