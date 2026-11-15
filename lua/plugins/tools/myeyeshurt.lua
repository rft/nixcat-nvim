-- Eye strain reminder via ascii snowflakes
-- https://github.com/wildfunctions/myeyeshurt

if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

return {
  {
    'wildfunctions/myeyeshurt',
    event = 'VeryLazy',
    opts = {
      useDefaultKeymaps = false,
      minutesUntilRest = 20,
      initialFlakes = 1,
      flakeOdds = 20,
      maxFlakes = 750,
      nextFrameDelay = 175,
      flake = { '*', '.' },
    },
    keys = {
      {
        '<leader>ts',
        function()
          require('myeyeshurt').start()
        end,
        desc = 'Start eye break reminder',
      },
      {
        '<leader>tx',
        function()
          require('myeyeshurt').stop()
        end,
        desc = 'Stop eye break reminder',
      },
    },
    config = function(_, opts)
      require('myeyeshurt').setup(opts)
    end,
  },
}
