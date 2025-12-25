return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Hide native mode/command display (lualine handles these)
    vim.opt.showmode = false
    vim.opt.cmdheight = 0


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
            color = { fg = "#ff9500", gui = "bold" },
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
          -- Sidekick NES status
          {
            function()
              local ok, nes = pcall(require, "sidekick.nes")
              if ok and nes.enabled then
                local count = nes.get and nes.get() and #nes.get() or 0
                if count > 0 then
                  return "NES:" .. count
                end
                return "NES"
              end
              return ""
            end,
            cond = function()
              local ok, nes = pcall(require, "sidekick.nes")
              return ok and nes.enabled
            end,
            color = { fg = "#a6e22e" },
          },
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
