-- LSP Configuration for Neovim 0.12+
-- Default configs come from nvim-lspconfig, with local overrides in nvim/lsp/*.lua
-- Mason-installed servers are auto-enabled by mason-lspconfig

local util = require("util")

vim.g.lsp_enabled = true
vim.g.diagnostic_virtual_text_enabled = false
vim.g.harper_enabled = true

-- Snapshot of enabled LSP configs, used to restore after toggle off/on.
local enabled_configs = {}

local function set_lsp_enabled(enabled)
  vim.g.lsp_enabled = enabled

  if not enabled then
    -- Snapshot currently enabled configs before disabling them.
    enabled_configs = {}
    for _, config in ipairs(vim.lsp.get_configs()) do
      if vim.lsp.is_enabled(config.name) then
        enabled_configs[config.name] = true
        vim.lsp.enable(config.name, false)
      end
    end
  else
    -- Restore previously enabled configs.
    for name, _ in pairs(enabled_configs) do
      if name == "copilot" and not util.copilot_available() then
        goto continue
      end
      vim.lsp.enable(name, true)
      ::continue::
    end
  end

  vim.diagnostic.enable(enabled)
  if not enabled then
    vim.diagnostic.reset()
  end
end

-- Enable Copilot LSP if available (provides NES via sidekick.nvim)
if util.copilot_available() then
  vim.lsp.enable("copilot")
end

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
  underline = true,
  update_in_insert = false, -- Only update diagnostics after leaving insert mode
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- Custom LSP keymaps (beyond Neovim 0.11+ defaults)
-- Built-in defaults: K (hover), gra (code action), grn (rename), grr (references),
--                    gri (implementation), grt (type def), grx (codelens), gO (symbols), <C-s> (signature)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buf = ev.buf }
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- Traditional navigation keymaps (in addition to defaults)
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")

    -- LSP actions (leader mappings)
    -- Note: Snacks picker keymaps (<leader>lr, <leader>lf, etc.) are in plugins/snacks.lua
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>lR", vim.lsp.buf.rename, "Rename symbol")

    -- Diagnostics
    map("n", "<leader>ld", vim.diagnostic.open_float, "Show diagnostics")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
  end,
})

-- Toggle LSP globally
vim.keymap.set("n", "<leader>tl", function()
  set_lsp_enabled(not vim.g.lsp_enabled)
  vim.notify("LSP " .. (vim.g.lsp_enabled and "enabled" or "disabled") .. " globally", vim.log.levels.INFO)
end, { desc = "Toggle LSP" })

-- Toggle diagnostic virtual text
vim.keymap.set("n", "<leader>td", function()
  vim.g.diagnostic_virtual_text_enabled = not vim.g.diagnostic_virtual_text_enabled
  vim.diagnostic.config({
    virtual_text = vim.g.diagnostic_virtual_text_enabled and {
      spacing = 4,
      prefix = "●",
    } or false,
  })
  vim.notify("Diagnostic virtual text " .. (vim.g.diagnostic_virtual_text_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle diagnostic virtual text" })

-- Toggle Harper grammar checker
vim.keymap.set("n", "<leader>th", function()
  vim.g.harper_enabled = not vim.g.harper_enabled
  vim.lsp.enable("harper_ls", vim.g.lsp_enabled and vim.g.harper_enabled)
  vim.notify("Harper " .. (vim.g.harper_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle Harper grammar checker" })

-- Toggle codelens (0.12+ built-in, run with grx)
vim.keymap.set("n", "<leader>tL", function()
  local enabled = not vim.lsp.codelens.is_enabled({ bufnr = 0 })
  vim.lsp.codelens.enable(enabled, { bufnr = 0 })
  vim.notify("Codelens " .. (enabled and "enabled" or "disabled") .. " (buffer)", vim.log.levels.INFO)
end, { desc = "Toggle codelens (buffer)" })
