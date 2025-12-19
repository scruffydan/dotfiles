return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "williamboman/mason.nvim" }, -- Mason provides tree-sitter-cli
  cond = function()
    -- Requires tree-sitter-cli and a C compiler
    local has_tree_sitter = vim.fn.executable("tree-sitter") == 1
    local has_cc = vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1
    if not has_tree_sitter or not has_cc then
      vim.defer_fn(function()
        vim.notify("nvim-treesitter: missing requirements (tree-sitter-cli and/or C compiler)", vim.log.levels.WARN)
      end, 100)
      return false
    end
    return true
  end,
  config = function()
    local ts = require("nvim-treesitter")

    -- Setup treesitter (uses default install_dir)
    ts.setup()

    -- Pre-install common parsers
    ts.install({
      "bash",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gotmpl",
      "gpg",
      "hcl",
      "helm",
      "html",
      "http",
      "ini",
      "javascript",
      "jinja",
      "jinja_inline",
      "jq",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "ssh_config",
      "terraform",
      "tmux",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "zsh",
    })

    -- Install other parsers on-demand and enable highlighting/indentation
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local ft = vim.bo.filetype
        if ft == "" then return end

        local lang = vim.treesitter.language.get_lang(ft) or ft

        -- Install parser if not already installed
        if not pcall(vim.treesitter.language.inspect, lang) then
          ts.install(lang)
        end

        -- Enable highlighting and indentation
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
