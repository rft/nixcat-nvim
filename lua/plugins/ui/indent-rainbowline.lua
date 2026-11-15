if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      -- NOTE: nixCats: built from the `plugins-indent-rainbowline` flake input,
      -- so the directory has no `.nvim` suffix. Tell lazy about that.
      { 'TheGLander/indent-rainbowline.nvim', name = 'indent-rainbowline' },
    },
    opts = function(_, opts)
      local defaults = {
        indent = {
          char = '│',
          tab_char = '│',
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            'help',
            'lazy',
            'neo-tree',
            'oil',
            'Trouble',
            'dashboard',
            'prompt',
          },
          buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
        },
      }

      opts = vim.tbl_deep_extend('force', defaults, opts or {})

      return require('indent-rainbowline').make_opts(opts, {
        color_transparency = 0.04,
      })
    end,
    keys = {
      {
        '<leader>ti',
        '<cmd>IBLToggle<cr>',
        desc = '[T]oggle [i]ndent guides',
      },
    },
  },
}
