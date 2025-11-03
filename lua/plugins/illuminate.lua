if not nixCats('general') then
  return {}
end

return {
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      delay = 200,
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
      modes_denylist = { 'i', 'v', 'V', string.char(22), 's', 'S', 't' },
      filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'fugitive',
        'git',
        'neo-tree',
        'lazy',
        'mason',
        'oil',
        'Outline',
        'TelescopePrompt',
        'snacks_dashboard',
      },
      min_count_to_highlight = 2,
    },
    config = function(_, opts)
      local illuminate = require 'illuminate'
      illuminate.configure(opts)

      local function map(key, direction, desc)
        vim.keymap.set('n', key, function()
          illuminate['goto_' .. direction .. '_reference'](false)
        end, { desc = desc })
      end

      map(']r', 'next', 'Next reference (illuminate)')
      map('[r', 'prev', 'Previous reference (illuminate)')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = opts.filetypes_denylist,
        callback = function()
          illuminate.pause_buf(0)
        end,
      })
    end,
  },
}
