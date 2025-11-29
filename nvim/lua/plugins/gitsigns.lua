return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
        untracked    = { text = "┆" },
      },
      signcolumn = "yes:1",
      numhl      = false,
      linehl     = false,
      word_diff  = false,
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc="Next hunk"})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc="Previous hunk"})
      end
    })
  end,
}
