return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- Disable default Copilot mapping so we can provide our own
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      -- Disable Copilot for transient buffers that should never get AI completion
      vim.g.copilot_filetypes = {
        snacks_picker_input = false,
        ['neo-tree'] = false,
        lazy = false,
        oil = false,
      }

      -- Accept suggestions with <Tab>, prioritising Sidekick NES before inline ghosts
      vim.keymap.set('i', '<Tab>', function()
        local sidekick_ok, sidekick = pcall(require, 'sidekick')
        if sidekick_ok and sidekick.nes_jump_or_apply() then
          return ''
        end

        local fallback = vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
        return vim.fn['copilot#Accept'](fallback)
      end, {
        expr = true,
        replace_keycodes = false,
        desc = 'Accept Copilot / Sidekick suggestion',
      })

      -- Toggle Copilot per-buffer
      vim.keymap.set('n', '<leader>cT', '<cmd>Copilot toggle<CR>', { desc = 'Copilot toggle buffer' })
    end,
  },
}
