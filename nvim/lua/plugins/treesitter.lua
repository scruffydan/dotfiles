return {
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
}
