return {
  "nvim-mini/mini.nvim",
  version = "*",
  event = { "InsertEnter", "LspAttach" },
  config = function()
    -- Auto-pair brackets, quotes, etc.
    --require("mini.pairs").setup({})

    -- Surround text objects with brackets, quotes, tags, etc.
    -- sa - add surround (saiw) to surround word, sa2j" to surround 2 lines)
    -- sd - delete surround (sd" to delete quotes)
    -- sr - replace surround (sr)" to replace parens with quotes)
    -- Custom: B for markdown bold (**), I for markdown italic (*)
    -- Ctrl-b and Ctrl-i in visual mode to add bold/italic
    require("mini.surround").setup({
      custom_surroundings = {
        -- Markdown bold (**)
        B = {
          input = { "%*%*().-()%*%*" },
          output = { left = "**", right = "**" },
        },
        -- Markdown italic (*)
        I = {
          input = { "%*().-()%*" },
          output = { left = "*", right = "*" },
        },
      },
    })

    -- Visual mode shortcuts for markdown bold/italic
    vim.keymap.set("x", "<C-b>", "saB", { remap = true, desc = "Add markdown bold" })
    vim.keymap.set("x", "<C-i>", "saI", { remap = true, desc = "Add markdown italic" })

    -- LSP completion with signature help
    -- Enabled/disabled by completion mode toggle (<leader>tc) in init.lua
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
  end,
}
