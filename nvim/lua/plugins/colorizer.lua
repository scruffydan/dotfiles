-- Inline color preview for hex codes, rgb values, etc.
return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      "*",
    }, {
      names = false,
    })
  end,
}
