-- SubMonokai colorscheme - loads immediately at startup
return {
  "scruffydan/submonokai-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd('colorscheme submonokai')
  end,
}
