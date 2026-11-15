return {
  {
    'folke/sidekick.nvim',
    event = 'VeryLazy',
    dependencies = {
      'folke/snacks.nvim',
    },
    opts = {
      nes = {
        debounce = 150,
      },
      cli = {
        win = {
          layout = 'right',
          split = {
            width = 80,
            height = 20,
          },
        },
        mux = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        '<leader>an',
        function()
          if not require('sidekick').nes_jump_or_apply() then
            vim.notify('No Copilot edit available yet', vim.log.levels.INFO, { title = 'Sidekick' })
          end
        end,
        desc = 'Sidekick apply next edit suggestion',
      },
      {
        '<leader>aN',
        function()
          require('sidekick.nes').toggle()
        end,
        desc = 'Sidekick toggle next edit suggestions',
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle { focus = true }
        end,
        mode = { 'n', 'v' },
        desc = 'Sidekick toggle CLI',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'v' },
        desc = 'Sidekick run prompt',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').send { selection = true }
        end,
        mode = { 'v' },
        desc = 'Sidekick send visual selection',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').focus()
        end,
        mode = { 'n', 'x', 'i', 't' },
        desc = 'Sidekick focus CLI window',
      },
    },
    config = function(_, opts)
      require('sidekick').setup(opts)
    end,
  },
}
