return {
  'christoomey/vim-tmux-navigator',
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate to left split/pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate to split/pane below" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate to split/pane above" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate to right split/pane" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate to previous split/pane" },
  },
}
