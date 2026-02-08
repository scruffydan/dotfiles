-- LSP Configuration for Neovim 0.11+
-- Default configs from nvim-lspconfig, overrides in nvim/after/lsp/*.lua
-- Mason-installed servers are auto-enabled by mason-lspconfig

-- Global defaults for all LSP servers
vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- Enable Copilot LSP if available (provides NES via sidekick.nvim)
if require("util").copilot_available() then
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
--                    gri (implementation), grt (type def), gO (symbols), <C-s> (signature)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- Traditional navigation keymaps (in addition to defaults)
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")

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

-- Helper function to iterate over all file buffers (excludes terminals, help, quickfix, etc.)
local function for_each_file_buffer(callback)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      callback(buf)
    end
  end
end

-- Toggle LSP globally
vim.g.lsp_enabled = true
vim.keymap.set("n", "<leader>tl", function()
  if vim.g.lsp_enabled then
    vim.lsp.stop_client(vim.lsp.get_clients())
    vim.diagnostic.reset()
    vim.g.lsp_enabled = false
    vim.notify("LSP disabled globally", vim.log.levels.INFO)
  else
    vim.g.lsp_enabled = true
    for_each_file_buffer(function(buf)
      vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
    end)
    vim.defer_fn(function()
      for_each_file_buffer(function(buf)
        vim.api.nvim_exec_autocmds("TextChanged", { buffer = buf })
      end)
    end, 1000)
    vim.notify("LSP enabled globally", vim.log.levels.INFO)
  end
end, { desc = "Toggle LSP" })

-- Toggle diagnostic virtual text
vim.g.diagnostic_virtual_text_enabled = false
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
vim.g.harper_enabled = true
vim.keymap.set("n", "<leader>th", function()
  vim.g.harper_enabled = not vim.g.harper_enabled
  vim.lsp.enable("harper_ls", vim.g.harper_enabled)
  vim.notify("Harper " .. (vim.g.harper_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle Harper grammar checker" })
