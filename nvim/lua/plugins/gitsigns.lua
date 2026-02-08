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
        border = "rounded",
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

        -- Navigation helper: handles diff mode fallback
        local function hunk_nav(direction, diff_key)
          return function()
            if vim.wo.diff then return diff_key end
            vim.schedule(function() gs.nav_hunk(direction) end)
            return '<Ignore>'
          end
        end
        map('n', ']h', hunk_nav('next', ']c'), {expr=true, desc="Next hunk"})
        map('n', '[h', hunk_nav('prev', '[c'), {expr=true, desc="Previous hunk"})

        -- Actions
        map('n', '<leader>hh', gs.preview_hunk, {desc="Preview hunk"})
        map('n', '<leader>gb', gs.blame, {desc="Git blame"})

        -- Stage/reset hunks
        map('n', '<leader>hs', gs.stage_hunk, {desc="Stage hunk"})
        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line("'<"), vim.fn.line("'>") })
        end, {desc="Stage selection"})
        map('n', '<leader>hr', gs.reset_hunk, {desc="Reset hunk"})
        map('v', '<leader>hr', function()
          gs.reset_hunk({ vim.fn.line("'<"), vim.fn.line("'>") })
        end, {desc="Reset selection"})
        map('n', '<leader>hu', gs.undo_stage_hunk, {desc="Undo stage hunk"})

        -- Toggle word diff highlighting
        map('n', '<leader>dw', gs.toggle_word_diff, {desc="Toggle word diff"})

        -- Preview inline hunk (auto-clears on cursor move)
        map('n', '<leader>di', gs.preview_hunk_inline, {desc="Preview inline diff"})

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc="Select hunk"})

      end
    })

    -- Close blame window with 'q'
    -- Since gitsigns blame window has filetype 'gitsigns-blame', we use an autocmd
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GitsignsBlameClose", { clear = true }),
      pattern = "gitsigns-blame",
      callback = function(event)
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close blame window" })
      end,
    })
  end,
}
