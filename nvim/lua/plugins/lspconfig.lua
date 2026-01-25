-- LSP configuration
-- nvim-lspconfig: Default configs for 300+ language servers
-- mason-lspconfig: Auto-enables Mason-installed servers

-- Skip mason-lspconfig on unsupported platforms (e.g., FreeBSD)
if not require("util").is_mason_supported then
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
