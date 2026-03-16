return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize" },
      pre_save = function()
        -- Skip saving sessions for special buffers and while in git commit messages
        local ignore_ft = {
          ["alpha"] = true,
          ["gitcommit"] = true,
          ["lazy"] = true,
        }
        return not ignore_ft[vim.bo.filetype]
      end,
    },
    config = function(_, opts)
      require("persistence").setup(opts)
    end,
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "[Q]uick [s]ession restore",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "[Q]uick session [S]elect",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "[Q]uick session restore [l]ast",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "[Q]uick session [d]isable",
      },
    },
  },
}
