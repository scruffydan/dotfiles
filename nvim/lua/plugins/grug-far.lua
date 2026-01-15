return {
  "MagicDuck/grug-far.nvim",
  opts = {
    -- Window opens as vertical split
    windowCreationCommand = "vsplit",

    -- Start in insert mode in the search field
    startInInsertMode = true,

    -- Debounce search while typing
    debounceMs = 500,
    minSearchChars = 2,

    -- Limit matches for performance
    maxSearchMatches = 2000,

    -- Manual search on leaving insert mode (set to true if you prefer)
    searchOnInsertLeave = false,
  },
  keys = {
    {
      "<leader>Sr",
      function()
        require("grug-far").open()
      end,
      desc = "Search and replace",
    },
    {
      "<leader>Sw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Search and replace word under cursor",
    },
    {
      "<leader>Sf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search and replace in current file",
    },
  },
}
