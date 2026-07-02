return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>a', group = '[A]I' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ebug/Document' },
        { '<leader>e', group = '[E]rror' },
        { '<leader>f', group = '[F]ile' },
        { '<leader>g', group = '[G]it' },
        { '<leader>j', group = '[J]ump' },
        { '<leader>l', group = '[L]SP' },
        { '<leader>m', group = '[M]notes' },
        { '<leader>mo', group = '[M]notes [O]bsidian' },
        { '<leader>n', group = '[N]eominimap' },
        { '<leader>o', group = '[O]pen' },
        { '<leader>p', group = '[P]roject' },
        { '<leader>q', group = '[Q]uick/quit' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]indow' },
        {
          mode = { 'v' },
          { '<leader>h', group = 'Git [H]unk' },
        },
      }
    end,
  },
}
