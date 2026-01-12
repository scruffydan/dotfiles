-- LSP and Mason configuration
-- Mason: Package manager for LSP servers and tools
-- nvim-lspconfig: Default configs for 300+ language servers
-- mason-lspconfig: Auto-enables Mason-installed servers

-- Prepend Mason bin to PATH at require time (before lazy.nvim processes cond checks)
-- This allows other plugins to find Mason-installed tools like tree-sitter-cli
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Check if we're on a supported platform for Mason binaries
local function is_supported_platform()
  local util = require("util")
  return util.is_linux or util.is_mac or util.is_windows
end

-- Skip Mason plugins on unsupported platforms (e.g., FreeBSD)
if not is_supported_platform() then
  return {
    { "neovim/nvim-lspconfig", lazy = false },
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
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
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- Auto-enable Mason-installed servers via vim.lsp.enable()
      -- Exclude copilot - enabled conditionally in lsp.lua
      automatic_enable = {
        exclude = { "copilot" },
      },
    },
  },
}
