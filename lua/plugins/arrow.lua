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
      leader_key = '<leader>al',
    },
    config = function(_, opts)
      local arrow = require 'arrow'
      local persist = require 'arrow.persist'
      arrow.setup(opts or {})

      vim.keymap.set('n', '<leader>aa', function()
        persist.toggle()
      end, { desc = '[A]rrow toggle current file' })

      vim.keymap.set('n', '<leader>an', function()
        persist.next()
      end, { desc = '[A]rrow [N]ext mark' })

      vim.keymap.set('n', '<leader>ap', function()
        persist.previous()
      end, { desc = '[A]rrow [P]revious mark' })

      local ui = require 'arrow.ui'
      vim.keymap.set('n', '<leader>al', function()
        ui.openMenu()
      end, { desc = '[A]rrow [L]ist marks' })

      for i = 1, 9 do
        local key = string.format('<leader>a%s', i)
        vim.keymap.set('n', key, function()
          persist.go_to(i)
        end, { desc = string.format('[A]rrow file %d', i) })
      end
    end,
  },
}
