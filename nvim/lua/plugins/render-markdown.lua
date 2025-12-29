return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  opts = {
    heading = {
      border = false,
    },
    code = {
      border = "rounded",
    },
  },
  keys = {
    { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
  },
}
