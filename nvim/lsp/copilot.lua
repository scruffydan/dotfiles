-- Copilot Language Server configuration for NES (Next Edit Suggestions)
-- Sign in with :LspCopilotSignIn
-- Sign out with :LspCopilotSignOut

-- Enable inline completion by default
vim.g.copilot_inline_enabled = vim.g.copilot_inline_enabled == nil and true or vim.g.copilot_inline_enabled

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

    -- Inline completion keymaps
    vim.keymap.set('i', '<C-e>', function()
      if vim.g.copilot_inline_enabled then
        vim.lsp.completion.trigger()
      end
    end, { buffer = bufnr, desc = 'Trigger inline completion' })

    vim.keymap.set('i', '<Tab>', function()
      if vim.g.copilot_inline_enabled and vim.lsp.completion.get() then
        vim.lsp.completion.accept()
        return ''
      end
      -- Check sidekick NES
      if require('sidekick').nes_jump_or_apply() then
        return ''
      end
      return '<Tab>'
    end, { buffer = bufnr, expr = true, desc = 'Accept inline completion or Tab' })

    vim.keymap.set('i', '<C-]>', function()
      vim.lsp.completion.dismiss()
    end, { buffer = bufnr, desc = 'Dismiss inline completion' })
  end,
}
