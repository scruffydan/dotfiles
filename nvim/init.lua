-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI Settings
vim.opt.number = true -- Add line numbers
-- Toggle relative line numbers
vim.keymap.set('n', '<leader>n', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end)
vim.opt.guicursor = ""  -- Prevent cursor from changing when switching modes
vim.opt.conceallevel = 0  -- Don't conceal characters
vim.opt.cursorline = true  -- Highlight current line
vim.opt.scrolloff = 8  -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8  -- Keep 8 columns visible left/right
vim.opt.showmode = false  -- Don't show mode (lualine displays it)
vim.opt.cmdheight = 0  -- Hide command line when not in use

-- Enable true color only if terminal supports it
if os.getenv("COLORTERM") == "truecolor" or os.getenv("COLORTERM") == "24bit" then
  vim.opt.termguicolors = true
end

-- Split behavior
vim.opt.splitright = true  -- Open vertical splits to the right
vim.opt.splitbelow = true  -- Open horizontal splits below

-- Use system clipboard (fails silently over SSH without clipboard provider)
vim.opt.clipboard = "unnamedplus"

-- Auto-detect git repo and set signcolumn
-- This walks up the directory tree from the current file to find a .git directory
-- If found, enables signcolumn for git signs (additions, deletions, modifications)
-- If not in a git repo, hides signcolumn to save screen space
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  group = augroup,
  pattern = '*',
  callback = function()
    local git_dir = vim.fn.finddir('.git', vim.fn.expand('%:p:h') .. ';')
    if git_dir ~= '' then
      vim.opt_local.signcolumn = 'yes:1'
    else
      vim.opt_local.signcolumn = 'no'
    end
  end,
})

-- Highlight the cursor line with a subtle background when entering insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('highlight CursorLine guibg=#1D1E19 ctermbg=236')
  end,
})

-- Remove the cursor line highlight when leaving insert mode
vim.api.nvim_create_autocmd('InsertLeave', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('highlight CursorLine guibg=NONE ctermbg=NONE')
  end,
})

-- Tab settings (2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Text wrapping behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Show invisible characters
vim.opt.listchars = {
  eol = '¬',
  tab = '>·',
  trail = '·',
  extends = '>',
  precedes = '<'
}
vim.opt.list = true

-- Buffer settings
vim.opt.hidden = true  -- Required for operations modifying multiple buffers

-- Performance settings
vim.opt.updatetime = 250  -- Faster completion and git signs
vim.opt.timeoutlen = 300  -- Faster key sequence completion

-- Search settings
vim.opt.ignorecase = true  -- Case insensitive search
vim.opt.smartcase = true   -- Unless uppercase used
vim.opt.incsearch = true   -- Incremental search
vim.opt.hlsearch = true    -- Highlight matches
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })  -- Clear highlights

-- Custom commands for quick tab width switching
-- :T2 switches to 2-space indentation (default for most projects)
-- :T4 switches to 4-space indentation (useful for Python, Java, etc.)
vim.api.nvim_create_user_command('T2', function()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
end, {})

vim.api.nvim_create_user_command('T4', function()
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true
end, {})

-- Add dotfiles nvim directory to runtime path and package path
-- This allows nvim to find plugins and config files in ~/dotfiles/nvim
-- even when nvim is started from a different directory
vim.opt.rtp:prepend(vim.fn.expand('~/dotfiles/nvim'))
package.path = package.path .. ';' .. vim.fn.expand('~/dotfiles/nvim/lua/?.lua')

-- Load plugins
require('plugins')

-- Notify user if telescope-fzf-native won't be available due to missing build tools
-- This runs at startup (VimEnter), before telescope is lazy-loaded, so the user
-- sees the notification immediately rather than when they first use telescope
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check which build tools are available on the system
    local has_cmake = vim.fn.executable('cmake') == 1
    local has_gmake = vim.fn.executable('gmake') == 1
    local has_make = vim.fn.executable('make') == 1
    local is_bsd = vim.fn.has('bsd') == 1

    -- Determine if we can build telescope-fzf-native
    -- On BSD: only cmake or gmake work (BSD's default make is incompatible)
    -- On other platforms: cmake, gmake, or make all work
    local can_build_fzf = false
    if is_bsd then
      can_build_fzf = has_cmake or has_gmake
    else
      can_build_fzf = has_cmake or has_gmake or has_make
    end

    -- If no compatible build tools are found, notify the user
    -- The 100ms delay ensures Neovim is fully loaded and the message is visible
    if not can_build_fzf then
      vim.defer_fn(function()
        vim.notify(
          "telescope: using native finder (install make/cmake/gmake for fzf)",
          vim.log.levels.INFO
        )
      end, 100)
    end
  end,
})
