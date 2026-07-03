local nixcats_utils = require 'nixCatsUtils'
local nixCats = _G.nixCats

if not nixcats_utils.enableForCategory 'orgmode' then
  return {}
end

local org_dir = nixcats_utils.getCatOrDefault({ 'orgmode', 'orgDir' }, '~/notes/org')
if type(org_dir) ~= 'string' or org_dir == '' then
  org_dir = '~/notes/org'
end
org_dir = vim.fn.expand(org_dir)

local index_file = org_dir .. '/index.org'
local journal_file = org_dir .. '/journal.org'

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

local orgmode_path = plugin_path 'orgmode'

local function ensure_org_dir()
  if vim.fn.isdirectory(org_dir) == 0 then
    vim.fn.mkdir(org_dir, 'p')
  end
end

return {
  {
    'nvim-orgmode/orgmode',
    name = 'orgmode',
    enabled = true,
    ft = 'org',
    cmd = 'Org',
    dir = orgmode_path,
    dependencies = {
      -- orgmode's init requires 'cmp' to register its completion source;
      -- without this, lazy loads nvim-cmp mid-require and hits a module loop
      'hrsh7th/nvim-cmp',
    },
    keys = {
      {
        '<leader>mw',
        function()
          vim.cmd.edit(org_dir)
        end,
        desc = '[M]notes open [w]orkspace',
      },
      {
        '<leader>mi',
        function()
          vim.cmd.edit(index_file)
        end,
        desc = '[M]notes workspace [i]ndex',
      },
      {
        '<leader>mj',
        function()
          require('orgmode').action('capture.open_template_by_shortcut', 'j')
        end,
        desc = '[M]notes [j]ournal today',
      },
      {
        '<leader>ms',
        function()
          Snacks.picker.files { cwd = org_dir, glob = '*.org' }
        end,
        desc = '[M]notes [s]earch notes',
      },
      {
        '<leader>ma',
        function()
          require('orgmode').action 'agenda.prompt'
        end,
        desc = '[M]notes org [a]genda',
      },
      {
        '<leader>mc',
        function()
          require('orgmode').action 'capture.prompt'
        end,
        desc = '[M]notes org [c]apture',
      },
    },
    opts = {
      org_agenda_files = { org_dir .. '/**/*' },
      org_default_notes_file = index_file,
      org_capture_templates = {
        t = {
          description = 'Task',
          template = '* TODO %?\n  %u',
        },
        j = {
          description = 'Journal',
          template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
          target = journal_file,
        },
      },
      -- Keep orgmode's global entry points inside the SPC m notes group;
      -- the defaults (<leader>oa / <leader>oc) collide with the SPC o Open group.
      mappings = {
        global = {
          org_agenda = '<leader>ma',
          org_capture = '<leader>mc',
        },
      },
    },
    config = function(_, opts)
      ensure_org_dir()
      require('orgmode').setup(opts)
    end,
  },
}
