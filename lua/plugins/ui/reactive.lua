-- Dynamic mode-based highlights
-- https://github.com/rasulomaroff/reactive.nvim

local nixCatsUtils = require 'nixCatsUtils'
local nixCats = _G.nixCats

local function resolve_plugin_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local candidates = { 'reactive-nvim', 'reactive.nvim', 'reactive' }

  for _, name in ipairs(candidates) do
    local start_path = nixCats.pawsible { 'allPlugins', 'start', name }
    if type(start_path) == 'string' and start_path ~= '' then
      return start_path
    end

    local opt_path = nixCats.pawsible { 'allPlugins', 'opt', name }
    if type(opt_path) == 'string' and opt_path ~= '' then
      return opt_path
    end
  end

  return nil
end

local function build_spec(source)
  local spec = {
    lazy = false,
    config = function()
      require('reactive').setup {
        builtin = {
          cursorline = true,
          cursor = true,
          modemsg = true,
        },
      }
    end,
  }

  if source.dir then
    spec.dir = source.dir
    spec.name = 'reactive.nvim'
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
