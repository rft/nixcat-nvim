local nixCatsUtils = require('nixCatsUtils')
local nixCats = _G.nixCats

local function resolve_sidekick_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local start_path = nixCats.pawsible { 'allPlugins', 'start', 'sidekick.nvim' }
  if type(start_path) == 'string' and start_path ~= '' then
    return start_path
  end

  local opt_path = nixCats.pawsible { 'allPlugins', 'opt', 'sidekick.nvim' }
  if type(opt_path) == 'string' and opt_path ~= '' then
    return opt_path
  end

  return nil
end

local function build_spec(source)
  local spec = {
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
  }

  if source.dir then
    spec.dir = source.dir
    spec.name = 'sidekick.nvim'
  else
    spec[1] = source.repo
  end

  return spec
end

local path = resolve_sidekick_path()
if path then
  return { build_spec { dir = path } }
end

return { build_spec { repo = 'folke/sidekick.nvim' } }
