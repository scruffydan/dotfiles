-- Prepend Mason bin to PATH immediately during require()
-- This runs before lazy.nvim processes plugin specs, so cond checks can find Mason tools
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

return {
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
    if registry.refresh then
      registry.refresh(function()
        ensure_installed("tree-sitter-cli")
        ensure_installed("copilot-language-server")
      end)
    else
      ensure_installed("tree-sitter-cli")
      ensure_installed("copilot-language-server")
    end
  end,
}
