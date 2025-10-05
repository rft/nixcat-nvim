return {
  -- Git integration
  {
    "NeogitOrg/neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open magit/neogit" },
    },
    config = function()
      require("neogit").setup {
        integrations = {
          diffview = true,
        },
      }
    end,
  },

  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewFileHistory',
      'DiffviewFocusFiles',
      'DiffviewRefresh',
      'DiffviewToggleFiles',
    },
    keys = {
      { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff [O]pen' },
      { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iff [C]lose' },
      { '<leader>gdf', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it [D]iff [F]ile history' },
      { '<leader>gdt', '<cmd>DiffviewToggleFiles<cr>', desc = '[G]it [D]iff [T]oggle files panel' },
    },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = 'diff2_horizontal',
          },
        },
        file_panel = {
          listing_style = 'tree',
          win_config = { width = 30 },
        },
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
          end,
        },
      }
    end,
  },

  -- Gitsigns with comprehensive git operations
  {
    'lewis6991/gitsigns.nvim',
    enabled = require('nixCatsUtils').enableForCategory("kickstart-gitsigns"),
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      -- Navigation
      { ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          require('gitsigns').nav_hunk 'next'
        end
      end, desc = 'Jump to next git [c]hange' },
      { '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          require('gitsigns').nav_hunk 'prev'
        end
      end, desc = 'Jump to previous git [c]hange' },

      -- Hunk operations following <leader>g pattern
      { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "[G]it [s]tage hunk" },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "[G]it [r]eset hunk" },
      { "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "[G]it [S]tage buffer" },
      { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "[G]it [u]ndo stage hunk" },
      { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "[G]it [R]eset buffer" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "[G]it [p]review hunk" },
      { "<leader>gb", function() require("gitsigns").blame_line() end, desc = "[G]it [b]lame line" },
      { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "[G]it [d]iff against index" },
      { "<leader>gD", function() require("gitsigns").diffthis('@') end, desc = "[G]it [D]iff against last commit" },

      -- Visual mode hunk operations
      { "<leader>gs", function() require("gitsigns").stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, desc = "[G]it [s]tage hunk", mode = 'v' },
      { "<leader>gr", function() require("gitsigns").reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, desc = "[G]it [r]eset hunk", mode = 'v' },

      -- Toggles
      { "<leader>gtb", function() require("gitsigns").toggle_current_line_blame() end, desc = "[G]it [t]oggle [b]lame line" },
      { "<leader>gtd", function() require("gitsigns").toggle_deleted() end, desc = "[G]it [t]oggle [d]eleted" },
    },
  },

  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>gB',
        function()
          require('snacks').gitbrowse()
        end,
        desc = '[G]it open in [B]rowser',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      gitbrowse = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
    end,
  },
}
