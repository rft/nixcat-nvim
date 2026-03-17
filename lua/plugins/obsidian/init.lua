local nixcats_utils = require('nixCatsUtils')
local nixCats = _G.nixCats

if not nixcats_utils.enableForCategory('obsidian') then
  return {}
end

local default_vaults = { personal = '~/notes/obsidian' }
local configured_vaults = nixcats_utils.getCatOrDefault({ 'obsidian', 'vaults' }, default_vaults)

local normalized_vaults = {}
for name, location in pairs(configured_vaults) do
  if type(name) == 'string' and name ~= '' and type(location) == 'string' and location ~= '' then
    normalized_vaults[name] = vim.fn.expand(location)
  end
end

if vim.tbl_isempty(normalized_vaults) then
  normalized_vaults = default_vaults
  for key, location in pairs(normalized_vaults) do
    normalized_vaults[key] = vim.fn.expand(location)
  end
end

local default_vault = nixcats_utils.getCatOrDefault({ 'obsidian', 'defaultVault' }, 'personal')
if type(default_vault) ~= 'string' or default_vault == '' or not normalized_vaults[default_vault] then
  default_vault = next(normalized_vaults)
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

local obsidian_path = plugin_path 'obsidian.nvim'

local function ensure_vault_dirs()
  for _, location in pairs(normalized_vaults) do
    if vim.fn.isdirectory(location) == 0 then
      vim.fn.mkdir(location, 'p')
    end
  end
end

-- Build workspaces list for obsidian.nvim config
local workspaces = {}
for name, path in pairs(normalized_vaults) do
  table.insert(workspaces, { name = name, path = path })
end

return {
  {
    'epwalsh/obsidian.nvim',
    name = 'obsidian',
    enabled = true,
    ft = 'markdown',
    dir = obsidian_path,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    cmd = { 'Obsidian' },
    keys = {
      {
        '<leader>mon',
        '<cmd>Obsidian new<cr>',
        desc = '[M]notes [O]bsidian [n]ew note',
      },
      {
        '<leader>moo',
        '<cmd>Obsidian open<cr>',
        desc = '[M]notes [O]bsidian [o]pen in app',
      },
      {
        '<leader>mos',
        '<cmd>Obsidian search<cr>',
        desc = '[M]notes [O]bsidian [s]earch',
      },
      {
        '<leader>moq',
        '<cmd>Obsidian quick-switch<cr>',
        desc = '[M]notes [O]bsidian [q]uick switch',
      },
      {
        '<leader>mob',
        '<cmd>Obsidian backlinks<cr>',
        desc = '[M]notes [O]bsidian [b]acklinks',
      },
      {
        '<leader>mot',
        '<cmd>Obsidian tags<cr>',
        desc = '[M]notes [O]bsidian [t]ags',
      },
      {
        '<leader>mod',
        '<cmd>Obsidian today<cr>',
        desc = '[M]notes [O]bsidian [d]aily note',
      },
      {
        '<leader>moy',
        '<cmd>Obsidian yesterday<cr>',
        desc = '[M]notes [O]bsidian [y]esterday',
      },
      {
        '<leader>mol',
        '<cmd>Obsidian link<cr>',
        mode = 'v',
        desc = '[M]notes [O]bsidian [l]ink selection',
      },
      {
        '<leader>moL',
        '<cmd>Obsidian link-new<cr>',
        mode = 'v',
        desc = '[M]notes [O]bsidian [L]ink new note',
      },
    },
    opts = {
      workspaces = workspaces,
      daily_notes = {
        folder = 'daily',
      },
      completion = {
        nvim_cmp = true,
      },
      -- Disable obsidian UI — markview.nvim already handles markdown rendering
      -- and sets conceallevel=3 which conflicts with obsidian's expectation of 1-2
      ui = {
        enable = false,
      },
      legacy_commands = false,
      new_notes_location = 'current_dir',
      wiki_link_func = function(opts)
        if opts.label ~= opts.path then
          return string.format('[[%s|%s]]', opts.path, opts.label)
        else
          return string.format('[[%s]]', opts.path)
        end
      end,
    },
    config = function(_, opts)
      ensure_vault_dirs()
      require('obsidian').setup(opts)
    end,
  },
}
