return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  cond = function()
    -- Requires tree-sitter-cli and a C compiler
    local has_tree_sitter = vim.fn.executable("tree-sitter") == 1
    local has_cc = vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1
    if not has_tree_sitter or not has_cc then
      vim.notify("nvim-treesitter: missing requirements (tree-sitter-cli and/or C compiler)", vim.log.levels.WARN)
      return false
    end
    return true
  end,
  config = function()
    local ts = require("nvim-treesitter")

    -- Setup treesitter (uses default install_dir)
    ts.setup()

    -- Parsers to ensure are installed
    local ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    }

    -- Install parsers (no-op if already installed)
    ts.install(ensure_installed)

    -- Enable highlighting and indentation for all filetypes with a parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
