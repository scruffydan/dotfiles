# Copilot NES Implementation Plan

Enable GitHub Copilot Next Edit Suggestions (NES) in Neovim via sidekick.nvim.

## Overview

NES (Next Edit Suggestions) provides AI-powered code refactoring suggestions that appear after you pause typing. Unlike inline completions (ghost text), NES suggests entire multi-line changes anywhere in your file.

## Prerequisites

- [x] Neovim >= 0.11.2 (you have v0.11.5)
- [x] sidekick.nvim installed
- [x] snacks.nvim installed (dependency)
- [x] mason.nvim and mason-lspconfig.nvim installed
- [ ] copilot-language-server installed via Mason
- [ ] GitHub Copilot subscription (free tier available)

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `nvim/lsp/copilot.lua` | **Create** | LSP configuration for copilot-language-server |
| `nvim/lua/plugins/lsp.lua` | **Modify** | Add `"copilot"` to ensure_installed, enable the LSP |
| `nvim/lua/plugins/sidekick.lua` | **Modify** | Add `<Tab>` keybinding for NES jump/apply |

---

## Step 1: Create `nvim/lsp/copilot.lua`

This file provides the LSP configuration that Neovim's native LSP client expects.

```lua
-- Copilot Language Server configuration for NES (Next Edit Suggestions)
-- Sign in with :LspCopilotSignIn
-- Sign out with :LspCopilotSignOut

local function sign_in(bufnr, client)
  client:request('signIn', vim.empty_dict(), function(err, result)
    if err then
      vim.notify(err.message, vim.log.levels.ERROR)
      return
    end
    if result.command then
      local code = result.userCode
      vim.fn.setreg('+', code)
      vim.fn.setreg('*', code)
      local continue = vim.fn.confirm(
        'Copied your one-time code to clipboard.\nOpen the browser to complete the sign-in process?',
        '&Yes\n&No'
      )
      if continue == 1 then
        client:exec_cmd(result.command, { bufnr = bufnr }, function(cmd_err, cmd_result)
          if cmd_err then
            vim.notify(cmd_err.message, vim.log.levels.ERROR)
            return
          end
          if cmd_result.status == 'OK' then
            vim.notify('Signed in as ' .. cmd_result.user .. '.')
          end
        end)
      end
    end
    if result.status == 'PromptUserDeviceFlow' then
      vim.notify('Enter your one-time code ' .. result.userCode .. ' in ' .. result.verificationUri)
    elseif result.status == 'AlreadySignedIn' then
      vim.notify('Already signed in as ' .. result.user .. '.')
    end
  end)
end

local function sign_out(_, client)
  client:request('signOut', vim.empty_dict(), function(err, result)
    if err then
      vim.notify(err.message, vim.log.levels.ERROR)
      return
    end
    if result.status == 'NotSignedIn' then
      vim.notify('Not signed in.')
    end
  end)
end

return {
  cmd = { 'copilot-language-server', '--stdio' },
  root_markers = { '.git' },
  init_options = {
    editorInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = 'off',
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignIn', function()
      sign_in(bufnr, client)
    end, { desc = 'Sign in to Copilot with GitHub' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignOut', function()
      sign_out(bufnr, client)
    end, { desc = 'Sign out of Copilot' })
  end,
}
```

---

## Step 2: Modify `nvim/lua/plugins/lsp.lua`

### 2a. Add copilot to mason-lspconfig ensure_installed

In the `mason-lspconfig.setup()` call, add `"copilot"`:

```lua
require("mason-lspconfig").setup({
  automatic_enable = true,
  ensure_installed = {
    "lua_ls",
    "marksman",
    "copilot",  -- Add this line
  },
})
```

### 2b. Enable the copilot LSP and add lsp/ path

Add the following near the top of the nvim-lspconfig config function (before any `vim.lsp.config` calls):

```lua
-- Add dotfiles lsp/ directory to Neovim's LSP config path
vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Source copilot config from dotfiles location
local copilot_config_path = vim.fn.expand('~/dotfiles/nvim/lsp/copilot.lua')
if vim.fn.filereadable(copilot_config_path) == 1 then
  vim.lsp.config('copilot', dofile(copilot_config_path))
end

-- Enable copilot LSP globally
vim.lsp.enable('copilot')
```

---

## Step 3: Modify `nvim/lua/plugins/sidekick.lua`

Add the `<Tab>` keybinding for NES to the `keys` table:

```lua
-- Add this to the keys table (before or after existing keymaps)
{
  "<tab>",
  function()
    -- Jump to next edit suggestion, or apply if at the edit location
    if not require("sidekick").nes_jump_or_apply() then
      return "<Tab>"  -- fallback to normal tab
    end
  end,
  expr = true,
  desc = "Goto/Apply Next Edit Suggestion",
  mode = { "n" },  -- normal mode only
},
```

---

## Post-Implementation Steps

1. **Restart Neovim** or run `:Lazy sync`
2. **Verify setup**: `:checkhealth sidekick`
3. **Sign in to Copilot**: `:LspCopilotSignIn`
   - This will copy a code to your clipboard and open GitHub in your browser
   - Paste the code to authenticate
4. **Test NES**:
   - Open a code file
   - Make some edits
   - Pause typing - NES suggestions should appear as inline diffs
   - Press `<Tab>` to jump to or apply suggestions

---

## Decisions Made

| Decision | Choice |
|----------|--------|
| Telemetry | `"off"` - disabled |
| Tab keybinding | Normal mode only (`mode = { "n" }`) |

---

## Troubleshooting

### NES not showing suggestions?

1. Run `:checkhealth sidekick` to verify setup
2. Check Copilot is signed in: `:LspCopilotSignIn`
3. Verify the LSP is attached: `:lua vim.print(vim.lsp.get_clients({ name = "copilot" }))`
4. Try manually triggering: `:Sidekick nes update`

### LSP not starting?

1. Verify Mason installed it: `:Mason` then search for `copilot`
2. Check the binary exists: `~/.local/share/nvim/mason/bin/copilot-language-server`
3. Check LSP logs: `:lua vim.cmd('edit ' .. vim.lsp.get_log_path())`

---

## Phase 2: Inline Completions (Future)

Once NES is working, inline completions (ghost text suggestions as you type) can be enabled by:

1. Adding `vim.lsp.inline_completion.enable(true, { bufnr = bufnr })` in the copilot `on_attach`
2. Adding keybindings for `vim.lsp.inline_completion.get` and `vim.lsp.inline_completion.select`
3. Optionally integrating with blink.cmp or other completion plugins

This is separate from NES and provides the traditional Copilot "autocomplete as you type" experience.

---

## References

- [sidekick.nvim](https://github.com/folke/sidekick.nvim)
- [copilot-language-server-release](https://github.com/github/copilot-language-server-release)
- [nvim-lspconfig copilot.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/copilot.lua)
