return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- Try cmake first, fall back to gmake (FreeBSD), then make (macOS/Linux)
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release || gmake || make",
      cond = function()
        -- Check if we have build tools available
        local has_cmake = vim.fn.executable('cmake') == 1
        local has_gmake = vim.fn.executable('gmake') == 1
        local has_make = vim.fn.executable('make') == 1

        -- On FreeBSD, default make won't work - need gmake or cmake
        if vim.fn.has('bsd') == 1 then
          return has_cmake or has_gmake
        end

        -- On other platforms, any build tool works
        return has_cmake or has_gmake or has_make
      end,
    },
  },
  config = function()
    require('telescope').setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Try to load fzf extension, fall back to native finder if it fails
    -- Silently falls back to native finder if fzf-native is not available
    pcall(require('telescope').load_extension, 'fzf')
  end,
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
  },
}
