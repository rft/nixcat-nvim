return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      -- Use Treesitter-powered textobjects with sensible fallbacks
      local ai = require 'mini.ai'
      ai.setup {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
          t = ai.gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
        },
      }

      -- Gate autopairs behind the nixCats category so nix options still apply
      if require('nixCatsUtils').enableForCategory 'kickstart-autopairs' then
        local pairs = require 'mini.pairs'
        pairs.setup {
          modes = { insert = true, command = false, terminal = false },
          mappings = {
            ['"'] = { register = { cr = true } },
            ["'"] = { register = { cr = true } },
            ['`'] = { register = { cr = true } },
          },
        }

        -- Disable autopairs where it tends to get in the way (prompts, tree UIs)
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'snacks_picker_input', 'oil', 'neo-tree', 'spectre_panel', 'minifiles' },
          callback = function()
            vim.b.minipairs_disable = true
          end,
        })

        -- Add tex-friendly dollar pairing when editing TeX buffers
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'tex', 'latex', 'plaintex' },
          callback = function()
            require('mini.pairs').map_buf(0, 'i', '$', { action = 'closeopen', pair = '$$' })
          end,
        })
      end

      require('mini.operators').setup {
        replace = { prefix = 'gs' },
        -- Keep gx free for open-url mapping in core/keymaps.lua
        exchange = { prefix = 'gX' },
        multiply = { prefix = 'gm' },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- Show cursor location as LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
