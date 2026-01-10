return {
  "lewis6991/gitsigns.nvim",
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
      signs_staged_enable = true,
      signcolumn = true,
      numhl      = false,
      linehl     = false,
      word_diff  = false,
      current_line_blame = false,
      preview_config = {
        border = 'rounded',
      },
      diff_opts = {
        algorithm = "histogram",  -- Better diff algorithm
        internal = true,          -- Use Neovim's built-in diff (faster)
        indent_heuristic = true,
        vertical = true,          -- Vertical splits by default
        linematch = 120,          -- Align lines within hunks for better readability
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.nav_hunk('next') end)
          return '<Ignore>'
        end, {expr=true, desc="Next hunk"})

        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.nav_hunk('prev') end)
          return '<Ignore>'
        end, {expr=true, desc="Previous hunk"})

        -- Actions
        map('n', '<leader>gH', gs.preview_hunk, {desc="Preview hunk"})
        map('n', '<leader>gB', gs.blame, {desc="Git blame"})

        -- Toggle word diff highlighting
        map('n', '<leader>dw', gs.toggle_word_diff, {desc="Toggle word diff"})

        -- Preview inline hunk (auto-clears on cursor move)
        map('n', '<leader>di', gs.preview_hunk_inline, {desc="Preview inline diff"})

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc="Select hunk"})
      end
    })
  end,
}
