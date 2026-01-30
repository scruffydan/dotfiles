return {
  "nvim-mini/mini.surround",
  version = "*",
  event = { "InsertEnter", "LspAttach" },
  config = function()
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
 end,
}
