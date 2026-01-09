-- Prepend Mason bin to PATH immediately during require()
-- This runs before lazy.nvim processes plugin specs, so cond checks can find Mason tools
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

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

      -- Auto-install tree-sitter-cli for nvim-treesitter
      local registry = require("mason-registry")
      local function ensure_installed(pkg_name)
        local ok, pkg = pcall(registry.get_package, pkg_name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end

      -- Ensure registry is up to date before checking packages
      registry.refresh(function()
        ensure_installed("tree-sitter-cli")
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_enable = true, -- Auto-enable installed LSP servers
        ensure_installed = {
          "lua_ls",
          "marksman",
          "harper_ls",
        },
      })
    end,
  },
}
