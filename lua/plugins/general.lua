return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Oil file browser
  {
    'stevearc/oil.nvim',
    keys = {
      {
        '<leader>fo',
        function()
          local oil = require 'oil'
          if vim.bo.filetype == 'oil' then
            oil.close()
          else
            oil.open()
          end
        end,
        desc = '[F]ile [o]il browser (toggle)',
      },
    },
    config = function()
      -- Everything not listed here keeps oil's defaults (:help oil-config)
      require('oil').setup {
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,
        keymaps = {
          -- :tcd to the current oil directory (oil's own default for this is g~)
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        },
        float = { border = 'rounded' },
        confirmation = { border = 'rounded' },
        progress = { border = 'rounded' },
      }

      local rename_group = vim.api.nvim_create_augroup('snacks_oil_rename', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = rename_group,
        pattern = 'OilActionsPost',
        callback = function(event)
          local data = event.data or {}
          local actions = data.actions or {}
          if actions.type == 'move' and actions.src_url and actions.dest_url then
            local function to_path(url)
              if type(url) == 'string' and url:match '^%w+://' then
                return vim.uri_to_fname(url)
              end
              return url
            end
            local from = to_path(actions.src_url)
            local dest = to_path(actions.dest_url)
            if from and dest then
              require('snacks').rename.on_rename_file(from, dest)
            end
          end
        end,
      })
    end,
  },

  -- Undotree
  {
    'mbbill/undotree',
    keys = {
      { '<leader>ou', '<cmd>UndotreeToggle<cr>', desc = '[O]pen [u]ndo tree' },
    },
    config = function()
      -- Configure undotree
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_DiffCommand = 'diff'
      vim.g.undotree_DiffpanelHeight = 10
      vim.g.undotree_HelpLine = 0
    end,
  },

  -- No Neck Pain - Center buffer for focused writing
  {
    'shortcuts/no-neck-pain.nvim',
    keys = {
      { '<leader>tn', '<cmd>NoNeckPain<cr>', desc = '[T]oggle [n]eck saver (center mode)' },
      {
        '<leader>t+',
        function()
          require('no-neck-pain').resize(vim.api.nvim_win_get_width(0) + 5)
        end,
        desc = '[T]oggle width [+] (increase)',
      },
      {
        '<leader>t-',
        function()
          require('no-neck-pain').resize(vim.api.nvim_win_get_width(0) - 5)
        end,
        desc = '[T]oggle width [-] (decrease)',
      },
    },
    config = function()
      require('no-neck-pain').setup {
        -- Width of the centered buffer
        width = 100,
        -- Buffer options
        buffers = {
          enabled = true,
          left = { enabled = true },
          right = { enabled = true },
          colors = {
            background = require('core.palette').darkTitanium, -- Dark background color
            blend = -0.2,
          },
          bo = {
            filetype = 'no-neck-pain',
            buftype = 'nofile',
            bufhidden = 'hide',
            buflisted = false,
            swapfile = false,
          },
          wo = {
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = '0',
            number = false,
            relativenumber = false,
            foldenable = false,
            list = false,
            wrap = false,
            linebreak = false,
          },
        },
        -- Integration with other plugins
        integrations = {
          NeoTree = {
            position = 'left',
            reopen = true,
          },
          NvimDAPUI = {
            position = 'none',
            reopen = true,
          },
        },
      }
    end,
  },
}
