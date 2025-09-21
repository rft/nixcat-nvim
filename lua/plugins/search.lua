return {
  -- Project-wide search
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Search whole project for string" },
    },
  },
}