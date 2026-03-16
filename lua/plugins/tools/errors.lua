return {
  -- Error management
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>ee", "<cmd>Trouble diagnostics toggle<cr>", desc = "Show errors" },
      { "<leader>ef", vim.lsp.buf.code_action, desc = "Fix error" },
      { "<leader>el", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "List errors" },
      { "<leader>en", function()
        require("trouble").next({skip_groups = true, jump = true})
      end, desc = "Next Error" },
      { "<leader>eN", function()
        require("trouble").prev({skip_groups = true, jump = true})
      end, desc = "Previous error" },
      { "<leader>ep", function()
        require("trouble").prev({skip_groups = true, jump = true})
      end, desc = "Previous error" },
    },
    config = function()
      require("trouble").setup({})
    end,
  },
}