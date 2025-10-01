local nixcats_utils = require('nixCatsUtils')
local nixCats = _G.nixCats

if not nixcats_utils.enableForCategory('neorg') then
  return {}
end

local default_workspaces = { notes = '~/notes/neorg' }
local configured_workspaces = nixcats_utils.getCatOrDefault({ 'neorg', 'workspaces' }, default_workspaces)

local normalized_workspaces = {}
for name, location in pairs(configured_workspaces) do
  if type(name) == 'string' and name ~= '' and type(location) == 'string' and location ~= '' then
    normalized_workspaces[name] = vim.fn.expand(location)
  end
end

if vim.tbl_isempty(normalized_workspaces) then
  normalized_workspaces = default_workspaces
  for key, location in pairs(normalized_workspaces) do
    normalized_workspaces[key] = vim.fn.expand(location)
  end
end

local default_workspace = nixcats_utils.getCatOrDefault({ 'neorg', 'defaultWorkspace' }, 'notes')
if type(default_workspace) ~= 'string' or default_workspace == '' or not normalized_workspaces[default_workspace] then
  default_workspace = next(normalized_workspaces)
end

local function plugin_path(name)
  if not nixCats or not nixCats.pawsible then
    return nil
  end

  local start_path = nixCats.pawsible { 'allPlugins', 'start', name }
  if type(start_path) == 'string' and start_path ~= '' then
    return start_path
  end

  local opt_path = nixCats.pawsible { 'allPlugins', 'opt', name }
  if type(opt_path) == 'string' and opt_path ~= '' then
    return opt_path
  end

  return nil
end

local neorg_path = plugin_path 'neorg'
local neorg_telescope_path = plugin_path 'neorg-telescope'

local function ensure_workspace_dirs()
  for _, location in pairs(normalized_workspaces) do
    if vim.fn.isdirectory(location) == 0 then
      vim.fn.mkdir(location, 'p')
    end
  end
end

return {
  {
    'nvim-neorg/neorg',
    name = 'neorg',
    enabled = true,
    build = nixcats_utils.lazyAdd(':Neorg sync-parsers', nil),
    ft = 'norg',
    cmd = 'Neorg',
    dir = neorg_path,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'nvim-neorg/neorg-telescope',
        name = 'neorg-telescope',
        dir = neorg_telescope_path,
      },
    },
    keys = {
      {
        '<leader>mw',
        function()
          vim.cmd('Neorg workspace ' .. default_workspace)
        end,
        desc = '[M]notes open default [W]orkspace',
      },
      {
        '<leader>mi',
        function()
          vim.cmd('Neorg index')
        end,
        desc = '[M]notes workspace [I]ndex',
      },
      {
        '<leader>mj',
        function()
          vim.cmd('Neorg journal today')
        end,
        desc = '[M]notes [J]ournal today',
      },
      {
        '<leader>ms',
        function()
          local ok, telescope = pcall(require, 'telescope')
          if ok and telescope.extensions and telescope.extensions.neorg and telescope.extensions.neorg.find_norg_files then
            telescope.extensions.neorg.find_norg_files()
          else
            vim.notify('Neorg telescope integration not available', vim.log.levels.WARN)
          end
        end,
        desc = '[M]notes [S]earch notes',
      },
    },
    opts = function()
      return {
        load = {
          ['core.defaults'] = {},
          ['core.concealer'] = {},
          ['core.summary'] = {},
          ['core.export'] = {},
          ['core.qol.todo_items'] = {},
          ['core.completion'] = {
            config = {
              engine = 'nvim-cmp',
            },
          },
          ['core.integrations.nvim-cmp'] = {},
          ['core.integrations.telescope'] = {},
          ['core.journal'] = {
            config = {
              workspace = default_workspace,
            },
          },
          ['core.dirman'] = {
            config = {
              workspaces = normalized_workspaces,
              default_workspace = default_workspace,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      ensure_workspace_dirs()
      require('neorg').setup(opts)
      pcall(require('telescope').load_extension, 'neorg')
    end,
  },
}
