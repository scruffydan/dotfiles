return {
  "NickvanDyke/opencode.nvim",

  event = "VeryLazy",

  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Uses snacks.nvim provider by default (you have it installed)
    }

    -- Required for opts.events.reload
    vim.o.autoread = true

    -- Keymaps with <leader>o prefix (OpenCode)
    vim.keymap.set({ "n", "x" }, "<leader>oo", function() require("opencode").toggle() end, { desc = "Toggle OpenCode" })
    vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "OpenCode select action" })
    vim.keymap.set({ "n", "x" }, "<leader>op", function() require("opencode").ask() end, { desc = "OpenCode prompt" })
    vim.keymap.set({ "n", "x" }, "<leader>ot", function() require("opencode").ask("@this: ", { submit = false }) end, { desc = "OpenCode ask about this" })
    vim.keymap.set({ "n", "x" }, "<leader>oe", function() require("opencode").prompt("explain") end, { desc = "OpenCode explain" })
    vim.keymap.set({ "n", "x" }, "<leader>or", function() require("opencode").prompt("review") end, { desc = "OpenCode review" })
    vim.keymap.set({ "n", "x" }, "<leader>of", function() require("opencode").prompt("fix") end, { desc = "OpenCode fix" })
    vim.keymap.set({ "n", "x" }, "<leader>od", function() require("opencode").prompt("document") end, { desc = "OpenCode document" })
    vim.keymap.set({ "n", "x" }, "<leader>oi", function() require("opencode").prompt("implement") end, { desc = "OpenCode implement" })
    vim.keymap.set({ "n", "x" }, "<leader>oz", function() require("opencode").prompt("optimize") end, { desc = "OpenCode optimize" })

    -- Operator for adding ranges
    vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { expr = true, desc = "Add range to OpenCode" })
    vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "Add line to OpenCode" })
  end,
}
