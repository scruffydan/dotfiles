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

  -- FZF fuzzy finder
  {
    "junegunn/fzf",
    build = function()
      vim.fn.system("./install --all")
    end,
    dir = "~/.fzf",
    lazy = true,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<C-p>", ":FZF<CR>", desc = "Open FZF" },
    },
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
          "javascript", "typescript", "tsx", "html", "css", "scss", "svelte", "vue",
          -- Data formats
          "json", "yaml", "toml", "xml", "proto", "prisma",
          -- Scripting
          "lua", "python", "bash", "zsh", "fish", "jq",
          -- Systems
          "c", "cpp", "rust", "go", "zig", "swift",
          -- JVM
          "java", "kotlin",
          -- Other
          "ruby", "php", "sql", "graphql", "elixir",
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
