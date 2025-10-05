return {
  {
    'lewis6991/satellite.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local util = require('satellite.util')
      local original_noautocmd = util.noautocmd

      util.noautocmd = function(fn)
        return original_noautocmd(function(...)
          if vim.in_fast_event() then
            return
          end

          local results = { pcall(fn, ...) }
          local ok = table.remove(results, 1)
          if not ok then
            local err = results[1]
            if type(err) == 'string' and err:match('E565: Not allowed to change text or change window') then
              return
            end
            error(err)
          end

          return unpack(results)
        end)
      end

      require('satellite').setup {
        current_only = false,
        winblend = 20,
        zindex = 40,
        width = 2,
        -- Avoid scratch-style neogit buffers that report inconsistent heights
        excluded_filetypes = {
          'neo-tree',
          'oil',
          'help',
          'lazy',
          'mason',
          'NeogitStatus',
          'NeogitPopup',
          'NeogitCommitMessage',
          'NeogitConsole',
          'NeogitNotification',
          'neogitstatus',
        },
        handlers = {
          search = { enable = true },
          diagnostic = { enable = true },
          gitsigns = { enable = true },
          marks = { enable = true },
        },
      }
    end,
  },
}
