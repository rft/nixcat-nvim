return {
  { -- Help break bad vim habits
    'm4xshen/hardtime.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>th',
        function()
          require('hardtime').toggle()
        end,
        desc = '[T]oggle [h]ardtime',
      },
    },
    opts = {
      enabled = true,
      -- Disable in certain filetypes
      disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil' },
      -- Maximum allowed repetitions
      max_count = 3,
      restriction_mode = 'block',
      -- Allow mouse actions
      allow_different_key = true,
      disabled_keys = {
        ['<Up>'] = {},
        ['<Down>'] = {},
        ['<Left>'] = {},
        ['<Right>'] = {},
        ['<ScrollWheelUp>'] = {},
        ['<ScrollWheelDown>'] = {},
        ['<C-ScrollWheelUp>'] = {},
        ['<C-ScrollWheelDown>'] = {},
        ['<S-ScrollWheelUp>'] = {},
        ['<S-ScrollWheelDown>'] = {},
      },
      -- Restricted keys
      restricted_keys = {
        ['h'] = { 'n', 'x' },
        ['j'] = { 'n', 'x' },
        ['k'] = { 'n', 'x' },
        ['l'] = { 'n', 'x' },
        ['-'] = { 'n', 'x' },
        ['+'] = { 'n', 'x' },
        ['gj'] = { 'n', 'x' },
        ['gk'] = { 'n', 'x' },
        ['<CR>'] = { 'n', 'x' },
        ['<C-M>'] = { 'n', 'x' },
        ['<C-N>'] = { 'n', 'x' },
        ['<C-P>'] = { 'n', 'x' },
      },
      -- Hints for better alternatives
      hints = {
        ['k^'] = {
          message = function()
            return 'Use - instead of k^'
          end,
          length = 2,
        },
      },
    },
  },
}
