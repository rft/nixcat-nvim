return {
  {
    'kndndrj/nvim-dbee',
    cmd = { 'DBee', 'DBeeToggle', 'DBeeExecute', 'DBeeBuffers', 'DBeeConnections' },
    keys = (function()
      local function with_dbee(action)
        return function()
          local ok, dbee = pcall(require, 'dbee')
          if not ok then
            local lazy_ok, lazy = pcall(require, 'lazy')
            if lazy_ok then
              lazy.load { plugins = { 'nvim-dbee' } }
              ok, dbee = pcall(require, 'dbee')
            end
          end

          if ok and dbee then
            action(dbee)
          else
            vim.notify('dbee.nvim is not available', vim.log.levels.WARN)
          end
        end
      end

      return {
        { '<leader>od', with_dbee(function(dbee) dbee.toggle() end), desc = 'Toggle database explorer' },
        {
          '<leader>oD',
          with_dbee(function(dbee)
            if type(dbee.focus) == 'function' then
              dbee.focus()
            elseif type(dbee.show) == 'function' then
              dbee.show()
            else
              dbee.open()
            end
          end),
          desc = 'Focus database explorer',
        },
        {
          '<leader>oe',
          with_dbee(function()
            local ok_cmd = pcall(vim.cmd, 'DBeeExecute')
            if not ok_cmd then
              vim.notify('DBeeExecute command is unavailable', vim.log.levels.WARN)
            end
          end),
          desc = 'Execute query (dbee)',
        },
      }
    end)(),
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local ok, dbee = pcall(require, 'dbee')
      if not ok then
        vim.notify('dbee.nvim failed to load', vim.log.levels.ERROR)
        return
      end

      local opts = {
        window = {
          position = 'right',
          width = 0.35,
          height = 0.8,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },
        results = {
          preview = {
            border = 'rounded',
          },
        },
        mappings = {
          close = 'q',
          execute = '<CR>',
          refresh = 'R',
        },
      }

      local status_ok = pcall(dbee.setup, opts)
      if not status_ok then
        dbee.setup {}
      end
    end,
  },
}
