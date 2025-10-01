return {
  -- Buffer management
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>bb", "<cmd>Telescope buffers cwd_only=true<cr>", desc = "Open buffer search (workspace)" },
      { "<leader>bB", "<cmd>Telescope buffers<cr>", desc = "Open all buffer search" },
      { "<leader>,", "<cmd>Telescope buffers cwd_only=true<cr>", desc = "Open buffer search (workspace)" },
      { "<leader><S-,>", "<cmd>Telescope buffers<cr>", desc = "Open all buffer search" },
      { "<leader>bc", function()
        local current = vim.api.nvim_get_current_buf()
        local listed = vim.tbl_filter(function(buf)
          return vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buflisted
            and vim.api.nvim_buf_is_loaded(buf)
        end, vim.api.nvim_list_bufs())

        if #listed > 1 then
          vim.cmd 'bnext'
        else
          vim.cmd 'enew'
        end

        if vim.api.nvim_buf_is_valid(current) then
          vim.cmd('bdelete ' .. current)
        end
      end, desc = "Close buffer" },
      { "<leader>bs", "<cmd>enew<cr>", desc = "Scratch buffer" },
      { "<leader>bu", "<cmd>e #<cr>", desc = "Reopen last buffer" },
    },
  },
  
  -- Buffer movement between windows
  {
    "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>bl", function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd("wincmd l")
        vim.api.nvim_set_current_buf(buf)
      end, desc = "Move buffer to right window" },
      
      { "<leader>bh", function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd("wincmd h")
        vim.api.nvim_set_current_buf(buf)
      end, desc = "Move buffer to left window" },
      
      { "<leader>bj", function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd("wincmd j")
        vim.api.nvim_set_current_buf(buf)
      end, desc = "Move buffer to lower window" },
      
      { "<leader>bk", function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd("wincmd k")
        vim.api.nvim_set_current_buf(buf)
      end, desc = "Move buffer to upper window" },
    },
  },
}
