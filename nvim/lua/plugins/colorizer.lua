-- Inline color preview for hex codes, rgb values, etc.
return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = { "*" },
    options = {
      parsers = {
        names = { enable = false },
      },
    },
  },
}
