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

    -- Parsers to ensure are installed
    local ensure_installed = {
      "awk",
      "bash",
      "c",
      "c_sharp",
      "cmake",
      "cpp",
      "css",
      "csv",
      "dart",
      "diff",
      "disassembly",
      "dockerfile",
      "editorconfig",
      "elixir",
      "fish",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gpg",
      "graphql",
      "groovy",
      "haskell",
      "hcl",
      "helm",
      "html",
      "http",
      "ini",
      "java",
      "javascript",
      "jq",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
      "kconfig",
      "kdl",
      "kotlin",
      "latex",
      "linkerscript",
      "llvm",
      "lua",
      "luadoc",
      "luau",
      "make",
      "markdown",
      "markdown_inline",
      "meson",
      "nasm",
      "nginx",
      "nix",
      "nu",
      "objdump",
      "passwd",
      "pem",
      "perl",
      "php",
      "powershell",
      "prisma",
      "proto",
      "puppet",
      "python",
      "query",
      "regex",
      "rst",
      "ruby",
      "rust",
      "scala",
      "scss",
      "sql",
      "ssh_config",
      "starlark",
      "strace",
      "svelte",
      "swift",
      "sxhkdrc",
      "tcl",
      "terraform",
      "tmux",
      "toml",
      "tsx",
      "typescript",
      "udev",
      "vim",
      "vimdoc",
      "vue",
      "xml",
      "yaml",
      "zig",
      "zsh",
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
