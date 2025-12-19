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
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
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
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")

          -- Diagnostics
          map("n", "<leader>cd", vim.diagnostic.open_float, "Show diagnostics")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
          map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        end,
      })

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
    end,
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
        },
      })
    end,
  },
}
