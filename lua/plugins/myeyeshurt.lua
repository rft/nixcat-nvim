-- Eye strain reminder via ascii snowflakes
-- https://github.com/wildfunctions/myeyeshurt

if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

local nixCatsUtils = require 'nixCatsUtils'
local nixCats = _G.nixCats

local function resolve_plugin_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local start_path = nixCats.pawsible { 'allPlugins', 'start', 'myeyeshurt' }
  if type(start_path) == 'string' and start_path ~= '' then
    return start_path
  end

  local opt_path = nixCats.pawsible { 'allPlugins', 'opt', 'myeyeshurt' }
  if type(opt_path) == 'string' and opt_path ~= '' then
    return opt_path
  end

  return nil
end

local function build_spec(source)
  local spec = {
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
  }

  if source.dir then
    spec.dir = source.dir
    spec.name = 'myeyeshurt'
  else
    spec[1] = source.repo
  end

  return spec
end

local plugin_path = resolve_plugin_path()

if not plugin_path then
  return {}
end

return { build_spec { dir = plugin_path } }
