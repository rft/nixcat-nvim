return {
  -- Jump operations
  {
    "folke/flash.nvim",
    keys = {
      { "<leader>jw", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Jump to word" },
      { "<leader>jl", "<cmd>lua vim.ui.input({ prompt = 'Go to line: ' }, function(input) if input then vim.cmd('normal! ' .. input .. 'G') end end)<cr>", desc = "Jump to line" },
    },
  },
  
  -- Jump to changes
  {
    "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>jc", "g;", desc = "Jump to previous change" },
      { "<leader>jC", "g,", desc = "Jump to next change" },
    },
  },
}