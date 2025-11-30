return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Define custom highlight for readonly
    vim.api.nvim_set_hl(0, 'LualineReadonly', { fg = '#ff9500', bold = true })

    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = { added = "● ", modified = "● ", removed = "● " },
          },
          "diagnostics",
        },
        lualine_c = {
          {
            "filename",
            symbols = { modified = "● ", readonly = "", unnamed = "[No Name]" },
          },
          {
            function()
              return vim.bo.readonly and "[RO]" or ""
            end,
            color = 'LualineReadonly',
            padding = 0,
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
