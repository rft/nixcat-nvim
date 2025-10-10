-- Code minimap overlay
-- https://github.com/Isrothy/neominimap.nvim

if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

local nixCatsUtils = require 'nixCatsUtils'
local nixCats = _G.nixCats

local function resolve_plugin_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local candidates = { 'neominimap', 'neoMiniMap', 'neominimap.nvim' }

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
    opts = {
      auto_enable = true,
      layout = 'float',
      float = {
        minimap_width = 18,
        margin = {
          right = 1,
          top = 0,
          bottom = 0,
        },
        persist = true,
      },
      git = {
        enabled = true,
      },
      diagnostic = {
        enabled = true,
        severity = { min = vim.diagnostic.severity.WARN },
      },
      search = {
        enabled = true,
      },
      click = {
        enabled = false,
      },
    },
    keys = {
      { '<leader>nt', '<cmd>Neominimap Toggle<cr>', desc = 'Toggle minimap' },
      { '<leader>ne', '<cmd>Neominimap Enable<cr>', desc = 'Enable minimap' },
      { '<leader>nd', '<cmd>Neominimap Disable<cr>', desc = 'Disable minimap' },
      { '<leader>nw', '<cmd>Neominimap WinToggle<cr>', desc = 'Toggle minimap for window' },
      { '<leader>nr', '<cmd>Neominimap Refresh<cr>', desc = 'Refresh minimap' },
      { '<leader>nf', '<cmd>Neominimap Focus<cr>', desc = 'Focus minimap' },
      { '<leader>nF', '<cmd>Neominimap Unfocus<cr>', desc = 'Unfocus minimap' },
    },
    init = function()
      vim.opt.wrap = false
      vim.opt.sidescrolloff = math.max(vim.opt.sidescrolloff:get(), 36)
    end,
    config = function(_, opts)
      vim.g.neominimap = vim.tbl_deep_extend('force', {}, opts or {})
    end,
  }

  if source.dir then
    spec.dir = source.dir
    spec.name = 'neominimap'
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
