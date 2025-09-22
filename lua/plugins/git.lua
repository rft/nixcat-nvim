return {
  -- Git integration
  {
    "NeogitOrg/neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open magit/neogit" },
    },
    config = function()
      require("neogit").setup({})
    end,
  },

  -- Git hunk operations
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "[G]it [r]evert hunk" },
      { "<leader>gR", function() require("gitsigns").stage_hunk() end, desc = "[G]it [R]edo (stage) hunk" },
    },
  },
}