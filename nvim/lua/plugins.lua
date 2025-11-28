-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
  -- Theme
  {
    "scruffydan/submonokai-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme submonokai')
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          highlight_opened_files = "name",
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        update_focused_file = {
          enable = true,
        },
      })
    end,
  },

  -- Treesitter (handles syntax highlighting, replaces vim-javascript)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          -- Web
          "javascript", "typescript", "tsx", "html", "css", "scss",
          -- Data formats
          "json", "yaml", "toml", "xml",
          -- Scripting
          "lua", "python", "bash", "jq",
          -- Systems
          "c", "cpp", "rust", "go",
          -- Other
          "ruby", "php", "sql", "graphql",
          -- Config/Doc
          "vim", "vimdoc", "markdown", "dockerfile", "terraform", "hcl", "make", "regex", "nginx", "cmake", "nix",
          -- Git
          "git_config", "gitcommit", "gitignore", "diff",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
})
