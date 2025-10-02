return {
  -- Project-wide search
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Search whole project for string" },
    },
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
}
