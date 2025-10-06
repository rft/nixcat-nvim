return {
  -- Project-wide search
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Search whole project for string" },
    },
  },

  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    dependencies = {
      'kkharji/sqlite.lua',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    opts = {},
    config = function()
      pcall(require('telescope').load_extension, 'smart_open')
    end,
  },

  -- Search match lens overlay
  {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local hlslens = require "hlslens"

      hlslens.setup {
        calm_down = true,
        nearest_only = true,
        nearest_float_when = "never",
        override_lens = function(_, _, _, _, _)
          -- suppress [n/total] virtual text; lualine already shows it
        end,
      }

      local function with_lens(key, with_count, desc)
        vim.keymap.set("n", key, function()
          local count = with_count and tostring(vim.v.count1) or ""
          local normal_cmd = count .. key
          vim.cmd("normal! " .. normal_cmd)
          hlslens.start()
        end, { silent = true, desc = desc })
      end

      with_lens("n", true, "Next search match (lens)")
      with_lens("N", true, "Previous search match (lens)")
      with_lens("*", false, "Search word under cursor (lens)")
      with_lens("#", false, "Search word backward (lens)")
      with_lens("g*", false, "Search partial word (lens)")
      with_lens("g#", false, "Search partial word backward (lens)")
    end,
  },

  {
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar', 'GrugFarWithSelection', 'GrugFarToggle' },
    keys = function()
      local function open_project()
        require('grug-far').open()
      end

      local function open_with_word()
        require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
      end

      local function open_with_selection()
        local grug = require 'grug-far'
        local prior = vim.fn.getreg 'v'
        local prior_type = vim.fn.getregtype 'v'
        vim.cmd [[noau normal! "vy]]
        local selection = vim.fn.getreg 'v'
        vim.fn.setreg('v', prior, prior_type)
        selection = selection and selection:gsub('\n$', '') or ''
        if selection == '' then
          grug.open()
        else
          grug.open { prefills = { search = selection } }
        end
      end

      return {
        { '<leader>sR', open_project, desc = '[S]earch [R]eplace project (grug-far)' },
        { '<leader>sW', open_with_word, desc = '[S]earch cursor [W]ord (grug-far)' },
        { '<leader>sR', open_with_selection, mode = 'v', desc = '[S]earch visual selection (grug-far)' },
      }
    end,
    opts = {},
    config = function(_, opts)
      require('grug-far').setup(opts)
    end,
  },
}
