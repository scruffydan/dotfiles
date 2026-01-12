return {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- Open oil file explorer with Shift+Tab in normal mode
    -- (Insert mode Shift+Tab is handled by sidekick.lua for dedenting)
    { "<S-Tab>", "<CMD>Oil<CR>", mode = "n", desc = "Open oil" },
  },
  config = function()
    require("oil").setup({
      delete_to_trash = vim.fn.has("macunix") == 1,
      watch_for_changes = true,
      cleanup_delay_ms = 0, -- Delete buffers immediately (oil opens fast enough)
      columns = {
        "icon",
      },
      float = {
        border = "rounded",
      },
      confirmation = {
        border = "rounded",
      },
      progress = {
        border = "rounded",
      },
      keymaps = {
        ["g."] = "actions.toggle_hidden",
        ["<leader>t."] = "actions.toggle_hidden",
        -- Tab/Shift+Tab behavior within oil buffers:
        -- Tab: Select file/directory (opens file or enters directory)
        -- Shift+Tab: Go to parent directory
        -- Note: In visual mode, Tab opens all selected files
        ["<Tab>"] = "actions.select",
        ["<S-Tab>"] = "actions.parent",
        ["<leader>cd"] = "actions.cd",
      },
      view_options = {
        show_hidden = true,
        case_insensitive = true,
        sort = {
          { "name", "asc" },
        },
        -- Highlight files that are currently open in a buffer
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
          if entry.type == "directory" then return end
          local oil_dir = require("oil").get_current_dir()
          if oil_dir and vim.fn.bufnr(oil_dir .. entry.name) ~= -1 then
            return "String"
          end
        end,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    })

    -- Workaround for oil.nvim bug: preview window doesn't update after error
    -- When a preview fails (e.g., PDF without ghostscript), the error message
    -- stays displayed. This patches open_preview to force buffer replacement.
    local oil = require("oil")
    local oil_util = require("oil.util")
    local original_open_preview = oil.open_preview
    oil.open_preview = function(opts, callback)
      local preview_win = oil_util.get_preview_win()
      if preview_win then
        -- Clear modified flag on current buffer so we can replace it
        local cur_buf = vim.api.nvim_win_get_buf(preview_win)
        vim.bo[cur_buf].modified = false
        -- Create a fresh empty buffer to clear any previous error state
        local empty_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[empty_buf].bufhidden = "wipe"
        vim.api.nvim_win_set_buf(preview_win, empty_buf)
        -- Clear the entry ID to ensure oil thinks it needs to update
        vim.w[preview_win].oil_entry_id = nil
      end
      return original_open_preview(opts, callback)
    end
  end,
}
