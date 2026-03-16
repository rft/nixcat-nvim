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
      leader_key = '<leader>wm',
    },
    config = function(_, opts)
      local arrow = require 'arrow'
      local persist = require 'arrow.persist'
      arrow.setup(opts or {})

      vim.keymap.set('n', '<leader>wt', function()
        persist.toggle()
      end, { desc = '[W]orkspace marks toggle' })

      vim.keymap.set('n', '<leader>wn', function()
        persist.next()
      end, { desc = '[W]orkspace marks next' })

      vim.keymap.set('n', '<leader>wp', function()
        persist.previous()
      end, { desc = '[W]orkspace marks previous' })

      local ui = require 'arrow.ui'
      vim.keymap.set('n', '<leader>wm', function()
        ui.openMenu()
      end, { desc = '[W]orkspace marks menu' })

      for i = 1, 9 do
        local key = string.format('<leader>w%s', i)
        vim.keymap.set('n', key, function()
          persist.go_to(i)
        end, { desc = string.format('[W]orkspace mark %d', i) })
      end
    end,
  },
}
