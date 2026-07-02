return {
  { -- Show vim motion hints
    'tris203/precognition.nvim',
    keys = {
      {
        '<leader>tp',
        function()
          require('precognition').toggle()
        end,
        desc = '[T]oggle [p]recognition hints',
      },
    },
    opts = {
      -- Keep hints hidden until explicitly toggled
      startVisible = false,
      showBlankVirtLine = true,
      -- Show hints for these motions
      hints = {
        Caret = { text = '^', prio = 2 },
        Dollar = { text = '$', prio = 0 }, -- Disabled by setting prio to 0
        MatchingParen = { text = '%', prio = 5 },
        Zero = { text = '0', prio = 0 }, -- Disabled by setting prio to 0
        w = { text = 'w', prio = 10 },
        b = { text = 'b', prio = 9 },
        e = { text = 'e', prio = 8 },
        W = { text = 'W', prio = 7 },
        B = { text = 'B', prio = 6 },
        E = { text = 'E', prio = 5 },
      },
      gutterHints = {
        G = { text = 'G', prio = 0 }, -- Disabled by setting prio to 0
        gg = { text = 'gg', prio = 0 }, -- Disabled by setting prio to 0
        PrevParagraph = { text = '{', prio = 8 },
        NextParagraph = { text = '}', prio = 8 },
      },
    },
  },
}
