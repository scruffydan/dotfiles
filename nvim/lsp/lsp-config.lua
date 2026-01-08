-- LSP Configuration
-- This file contains LSP setup that runs after plugins are loaded

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
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- LSP keymaps (set on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

    -- Actions
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("v", "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>lR", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>lr", function() Snacks.picker.lsp_references() end, "References")
    map("n", "<leader>lf", function() Snacks.picker.lsp_definitions() end, "Find definitions")

    -- Diagnostics
    map("n", "<leader>ld", vim.diagnostic.open_float, "Show diagnostics")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
  end,
})

-- Toggle LSP globally (available in all buffers)
vim.g.lsp_enabled = true
vim.keymap.set("n", "<leader>tl", function()
  if vim.g.lsp_enabled then
    vim.lsp.stop_client(vim.lsp.get_clients())
    vim.diagnostic.reset()
    vim.g.lsp_enabled = false
    vim.notify("LSP disabled globally", vim.log.levels.INFO)
  else
    vim.g.lsp_enabled = true
    -- Trigger FileType event to re-attach LSP to all buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
        vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
      end
    end
    -- Refresh display after LSP attaches and sends diagnostics
    vim.defer_fn(function()
      -- Trigger a text change event to request fresh diagnostics
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
          vim.api.nvim_exec_autocmds("TextChanged", { buffer = buf })
        end
      end
    end, 1000)
    vim.notify("LSP enabled globally", vim.log.levels.INFO)
  end
end, { desc = "Toggle LSP" })

-- Configure lua_ls
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "vim", "Snacks" },
        enable = true,
      },
    },
  },
})

-- Configure mason-lspconfig
require("mason-lspconfig").setup({
  automatic_enable = true, -- Auto-enable installed LSP servers
  ensure_installed = { "lua_ls", "marksman" },
})

-- Load copilot LSP configuration
local copilot_lsp_path = vim.fn.expand('~/dotfiles/nvim/lsp/copilot.lua')
if vim.fn.filereadable(copilot_lsp_path) == 1 then
  dofile(copilot_lsp_path)
end
