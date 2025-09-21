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
}