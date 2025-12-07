return {
  "nvimdev/indentmini.nvim",
  event = "BufEnter",
  config = function()
    require("indentmini").setup({
      char = "│",
      exclude = {
        "help",
        "dashboard",
        "lazy",
        "mason",
        "oil",
      },
    })
    -- Set indent line color to match listchars (NonText)
    vim.api.nvim_set_hl(0, "IndentLine", { link = "NonText" })
  end,
}
