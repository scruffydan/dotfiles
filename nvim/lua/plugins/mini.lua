return {
  "nvim-mini/mini.nvim",
  version = "*",
  event = { "InsertEnter", "LspAttach" },
  config = function()
    -- Auto-pair brackets, quotes, etc.
    require("mini.pairs").setup({})

    -- LSP completion with signature help
    require("mini.completion").setup({
      delay = {
        completion = 100,
        info = 100,
        signature = 50,
      },
      window = {
        info = { border = "rounded" },
        signature = { border = "rounded" },
      },
      lsp_completion = {
        source_func = "omnifunc",
        auto_setup = true,
      },
    })

    -- Use <C-Space> to trigger completion manually
    vim.keymap.set("i", "<C-Space>", function()
      return vim.fn.pumvisible() == 1 and "" or "<C-x><C-o>"
    end, { expr = true, desc = "Trigger completion" })

    -- Disable completion for certain filetypes/buftypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "snacks_input", "snacks_picker_input" },
      callback = function()
        vim.b.minicompletion_disable = true
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local buftype = vim.bo.buftype
        if buftype == "prompt" or buftype == "nofile" then
          vim.b.minicompletion_disable = true
        end
      end,
    })
  end,
}
