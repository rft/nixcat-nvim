if not nixCats('general') then
  return {}
end

return {
  {
    'B0o/dropbar.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local ok, dropbar = pcall(require, 'dropbar')
      if not ok then
        return
      end

      dropbar.setup()

      local ok_api, api = pcall(require, 'dropbar.api')
      if ok_api then
        vim.keymap.set('n', '<leader>wp', api.pick, { desc = '[W]inbar pick symbol (dropbar)' })
        vim.keymap.set('n', '<leader>wm', function()
          api.pick(vim.api.nvim_get_current_win())
        end, { desc = '[W]inbar pick in current window (dropbar)' })
      end

      local ignored_filetypes = {
        'neo-tree',
        'oil',
        'snacks_dashboard',
        'toggleterm',
        'TelescopePrompt',
      }

      vim.api.nvim_create_autocmd('BufWinEnter', {
        callback = function(event)
          local ft = vim.bo[event.buf].filetype
          if vim.tbl_contains(ignored_filetypes, ft) then
            local win = vim.fn.bufwinid(event.buf)
            if win ~= -1 and vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_set_option(win, 'winbar', '')
            end
          end
        end,
      })
    end,
  },
}
