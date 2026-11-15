-- Code minimap overlay
-- https://github.com/Isrothy/neominimap.nvim

if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

return {
  {
    'Isrothy/neominimap.nvim',
    -- NOTE: nixCats: built from the `plugins-neominimap` flake input, so the
    -- directory is called neominimap. Tell lazy about that.
    name = 'neominimap',
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
        enabled = true,
        auto_switch_focus = true,
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
  },
}
