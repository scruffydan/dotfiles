return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Hide native mode display (lualine handles it)
    vim.opt.showmode = false

    require("lualine").setup({
      options = {
        theme = "submonokai",
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
          },
        },
        lualine_b = {
          {
            "filename",
            symbols = { modified = "● ", readonly = "", unnamed = "[No Name]" },
          },
          {
            function()
              return vim.bo.readonly and "[RO]" or ""
            end,
            color = { fg = "#ff9500", gui = "bold" },
            padding = 0,
          },
        },
        lualine_c = {
          {
            "searchcount",
            timeout = 500,
            cond = function()
              return vim.v.hlsearch ~= 0
            end,
          },
          {
            "branch",
            cond = function()
              return vim.v.hlsearch == 0
            end,
          },
          {
            "diff",
            symbols = { added = "● ", modified = "● ", removed = "● " },
            cond = function()
              return vim.v.hlsearch == 0
            end,
          },
          "diagnostics",
          {
            function()
              return vim.ui.progress_status() or ""
            end,
            cond = function()
              return vim.ui.progress_status() ~= nil
            end,
          },
        },
        lualine_x = {
          -- Sidekick CLI session status
          {
            function()
              local status = require("sidekick.status").cli()
              return " " .. (#status > 1 and #status or "")
            end,
            cond = function()
              return #require("sidekick.status").cli() > 0
            end,
            color = "Special",
          },
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

    vim.api.nvim_create_autocmd({ "Progress", "LspProgress" }, {
      group = vim.api.nvim_create_augroup("LualineProgressRefresh", { clear = true }),
      callback = function()
        vim.cmd.redrawstatus()
      end,
    })
  end,
}
