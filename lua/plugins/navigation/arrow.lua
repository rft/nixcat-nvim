-- Arrow quick file navigator
-- https://github.com/otavioschwanck/arrow.nvim

if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

return {
  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      show_icons = true,
      leader_key = '<leader>pmm',
    },
    config = function(_, opts)
      local arrow = require 'arrow'
      local persist = require 'arrow.persist'
      arrow.setup(opts or {})

      vim.keymap.set('n', '<leader>pmt', function()
        persist.toggle()
      end, { desc = 'Workspace [M]arks toggle' })

      vim.keymap.set('n', '<leader>pmn', function()
        persist.next()
      end, { desc = 'Workspace [M]arks next' })

      vim.keymap.set('n', '<leader>pmp', function()
        persist.previous()
      end, { desc = 'Workspace [M]arks previous' })

      local ui = require 'arrow.ui'
      vim.keymap.set('n', '<leader>pmm', function()
        ui.openMenu()
      end, { desc = 'Workspace [M]arks menu' })

      for i = 1, 9 do
        local key = string.format('<leader>pm%s', i)
        vim.keymap.set('n', key, function()
          persist.go_to(i)
        end, { desc = string.format('Workspace [M]ark %d', i) })
      end
    end,
  },
}
