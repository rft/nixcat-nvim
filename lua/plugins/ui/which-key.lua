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
        { '<leader>gd', group = '[G]it [D]iff' },
        { '<leader>gt', group = '[G]it [T]oggle' },
        { '<leader>j', group = '[J]ump' },
        { '<leader>jt', group = '[J]ump [T]reesitter', mode = { 'n', 'x', 'o' } },
        { '<leader>l', group = '[L]SP' },
        { '<leader>m', group = '[M]notes' },
        { '<leader>mo', group = '[M]notes [O]bsidian' },
        { '<leader>n', group = '[N]eominimap' },
        { '<leader>o', group = '[O]pen' },
        { '<leader>p', group = '[P]roject' },
        { '<leader>pm', group = 'Workspace [M]arks' },
        { '<leader>q', group = '[Q]uick/quit' },
        { '<leader>r', group = '[R]EPL', mode = { 'n', 'v' } },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]indow' },
        {
          mode = { 'v' },
          { '<leader>c', group = '[C]ode' },
          { '<leader>g', group = '[G]it' },
        },
      }
    end,
  },
}
