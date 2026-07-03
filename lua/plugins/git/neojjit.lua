return {
  -- Jujutsu (jj) integration, magit-style UI like neogit
  {
    'JulianNymark/neojjit',
    keys = {
      {
        '<leader>gj',
        function()
          require('neojjit').open()
        end,
        desc = '[G]it open neo[j]jit (jujutsu)',
      },
    },
    config = function()
      require('neojjit').setup {}
    end,
  },
}
