return {
  {
    'folke/persistence.nvim',
    -- Loaded eagerly so setup() has run before the snacks dashboard's
    -- session action calls require('persistence').load() directly.
    lazy = false,
    opts = {},
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = '[Q]uick [s]ession restore',
      },
      {
        '<leader>qS',
        function()
          require('persistence').select()
        end,
        desc = '[Q]uick session [S]elect',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = '[Q]uick session restore [l]ast',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = '[Q]uick session [d]isable',
      },
    },
  },
}
