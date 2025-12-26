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
        completion = 1000,
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

    -- Completion mode: "copilot" | "native" | "off"
    -- Default to copilot inline completions
    vim.g.completion_mode = vim.g.completion_mode or "copilot"

    -- Disable mini.completion by default when in copilot mode
    if vim.g.completion_mode == "copilot" then
      vim.g.minicompletion_disable = true
    end

    -- Toggle completion mode: copilot -> native -> off -> copilot
    vim.keymap.set("n", "<leader>tc", function()
      local modes = { "copilot", "native", "off" }
      local current = vim.g.completion_mode or "copilot"
      local idx = 1
      for i, mode in ipairs(modes) do
        if mode == current then
          idx = i
          break
        end
      end
      local next_mode = modes[(idx % #modes) + 1]
      vim.g.completion_mode = next_mode

      -- Update copilot and mini.completion states
      if next_mode == "copilot" then
        vim.g.copilot_enabled = true
        vim.g.minicompletion_disable = true
      elseif next_mode == "native" then
        vim.g.copilot_enabled = false
        vim.g.minicompletion_disable = false
      else -- off
        vim.g.copilot_enabled = false
        vim.g.minicompletion_disable = true
      end

      vim.notify("Completion: " .. next_mode, vim.log.levels.INFO)
    end, { desc = "Cycle completion (copilot/native/off)" })
  end,
}
