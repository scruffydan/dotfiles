return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("fzf-lua").setup({
      files = {
        formatter = "path.dirname_first",
      },
    })
  end,
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Diagnostics" },
    { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
    { "<leader>/", "<cmd>FzfLua blines<CR>", desc = "Search buffer" },
    {
      "<leader>fs",
      function()
        local word = vim.fn.expand('<cword>')
        local suggestions = vim.fn.spellsuggest(word)

        if #suggestions == 0 then
          vim.notify("No spelling suggestions for '" .. word .. "'", vim.log.levels.INFO)
          return
        end

        require('fzf-lua').fzf_exec(suggestions, {
          prompt = 'Spelling> ',
          winopts = {
            height = 0.3,
            width = 0.4,
            row = 0.5,
            col = 0.5,
          },
          actions = {
            ['default'] = function(selected)
              if selected and selected[1] then
                vim.cmd('normal! ciw' .. selected[1])
              end
            end,
          },
        })
      end,
      desc = "Spell check word under cursor"
    },
  },
}
