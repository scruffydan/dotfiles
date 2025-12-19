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

    -- Toggle autocompletion
    vim.keymap.set("n", "<leader>tc", function()
      vim.b.minicompletion_disable = not vim.b.minicompletion_disable
      vim.notify(vim.b.minicompletion_disable and "Completion: off" or "Completion: on", vim.log.levels.INFO)
    end, { desc = "Toggle completion" })
  end,
}
