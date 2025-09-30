return {
  -- Jump operations
  {
    'folke/flash.nvim',
    keys = {
      {
        '<leader>jw',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Jump to word',
      },
      {
        '<leader>jt',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Jump to treesitter node',
      },
      {
        '<leader>jr',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote flash',
      },
      {
        '<leader>jR',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter search',
      },
      {
        '<leader>jl',
        "<cmd>lua vim.ui.input({ prompt = 'Go to line: ' }, function(input) if input then vim.cmd('normal! ' .. input .. 'G') end end)<cr>",
        desc = 'Jump to line',
      },
    },
    config = function()
      require('flash').setup {
        -- Labels to use for flash jumps
        labels = 'asdfghjklqwertyuiopzxcvbnm',
        search = {
          -- Show search in command line
          mode = 'exact',
          -- Maximum number of search results
          max_length = false,
        },
        jump = {
          -- Save location in jumplist
          jumplist = true,
          -- Jump position
          pos = 'start',
          -- Clear highlight after jump
          history = false,
          register = false,
        },
        label = {
          -- Allow uppercase labels
          uppercase = true,
          -- Show labels after pattern
          after = true,
          before = true,
          -- Label style
          style = 'overlay',
        },
        highlight = {
          -- Highlight settings
          backdrop = true,
          matches = true,
          priority = 5000,
        },
        -- Treesitter mode configuration
        modes = {
          search = {
            enabled = true,
          },
          char = {
            enabled = true,
            jump_labels = true,
          },
          treesitter = {
            labels = 'abcdefghijklmnopqrstuvwxyz',
            jump = { pos = 'range' },
            search = { incremental = false },
            label = { before = true, after = true, style = 'inline' },
            highlight = {
              backdrop = false,
              matches = false,
            },
          },
        },
      }
    end,
  },

  -- Jump to changes
  {
    'nvim-lua/plenary.nvim',
    keys = {
      { '<leader>jC', 'g;', desc = 'Jump to previous change' },
      { '<leader>jc', 'g,', desc = 'Jump to next change' },
    },
  },

  -- Enhanced f/F movement with unique indicators
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require('eyeliner').setup {
        highlight_on_key = true,
        dim = true,
        max_length = 9999,
        disabled_filetypes = {
          'neo-tree',
          'toggleterm',
          'help',
          'oil',
          'trouble',
        },
        disabled_buftypes = {
          'nofile',
          'terminal',
          'quickfix',
        },
        default_keymaps = true,
      }
    end,
  },
}

