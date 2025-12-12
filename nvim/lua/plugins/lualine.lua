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
        lualine_a = {
          "mode",
          {
            function()
              local reg = vim.fn.reg_recording()
              return reg ~= "" and "recording @" .. reg or ""
            end,
            color = { fg = "#ff6666", gui = "bold" },
          },
        },
        lualine_b = {
          {
            "searchcount",
            maxcount = 999,
            timeout = 500,
            cond = function()
              return vim.v.hlsearch ~= 0
            end,
          },
          {
            "filename",
            symbols = { modified = "● ", readonly = "", unnamed = "[No Name]" },
            cond = function()
              return vim.v.hlsearch == 0
            end,
          },
          {
            function()
              return vim.bo.readonly and "[RO]" or ""
            end,
            color = 'LualineReadonly',
            padding = 0,
          },
        },
        lualine_c = {
          "branch",
          {
            "diff",
            symbols = { added = "● ", modified = "● ", removed = "● " },
          },
          "diagnostics",
        },
        lualine_x = {
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            end,
            icon = '',
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
