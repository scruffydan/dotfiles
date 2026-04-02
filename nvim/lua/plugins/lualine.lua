return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local in_tmux = vim.env.TMUX ~= nil
    local ui = vim.api.nvim_list_uis()[1]
    -- tmux passthrough only works when Neovim is attached to a tty-backed UI.
    local can_tmux_passthrough = in_tmux and ui and ui.stdout_tty

    local function tmux_progress_send(sequence)
      if not can_tmux_passthrough then
        return
      end

      -- Wrap OSC 9;4 in tmux's DCS passthrough so Ghostty can see it outside tmux.
      vim.api.nvim_ui_send("\027Ptmux;\027\027]" .. sequence .. "\007\027\\")
    end

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
          -- Copilot LSP status (shows when NES is enabled and attached, color indicates state)
          {
            function()
              return "NES"
            end,
            color = function()
              local status = require("sidekick.status").get()
              if not status then return "DiagnosticInfo" end
              if status.kind == "Error" then return "DiagnosticError" end
              if status.busy then return "DiagnosticWarn" end
              return "DiagnosticInfo"
            end,
            cond = function()
              local nes = package.loaded["sidekick.nes"]
              local status = package.loaded["sidekick.status"]
              return nes and nes.enabled and status and status.get() ~= nil
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

    if can_tmux_passthrough then
      vim.api.nvim_create_autocmd("Progress", {
        group = vim.api.nvim_create_augroup("TmuxGhosttyProgress", { clear = true }),
        desc = "Forward Neovim progress to the outer terminal through tmux",
        callback = function(ev)
          -- Match Neovim's builtin OSC 9;4 behavior, but send it through tmux.
          if ev.data.status == "running" then
            tmux_progress_send(string.format("9;4;1;%d", ev.data.percent or 0))
          else
            tmux_progress_send("9;4;0;0")
          end
        end,
      })
    end
  end,
}
