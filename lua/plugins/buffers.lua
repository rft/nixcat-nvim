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
        local buf = vim.api.nvim_get_current_buf()
        local force_delete = false

        if vim.bo[buf].modified then
          local choice = vim.fn.confirm('Save changes to this buffer?', '&Yes\n&No\n&Cancel', 1)
          if choice == 1 then
            if not pcall(vim.cmd.write) then
              return
            end
          elseif choice == 2 then
            force_delete = true
          else
            return
          end
        end

        local listed = vim.tbl_filter(function(b)
          return vim.api.nvim_buf_is_valid(b)
            and vim.bo[b].buflisted
            and vim.api.nvim_buf_is_loaded(b)
        end, vim.api.nvim_list_bufs())

        if #listed > 1 then
          vim.cmd 'bnext'
        else
          vim.cmd 'enew'
        end

        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = force_delete })
        end
      end, desc = "Close buffer" },
      { "<leader>bs", "<cmd>enew<cr>", desc = "Scratch buffer" },
      { "<leader>bu", "<cmd>e #<cr>", desc = "Reopen last buffer" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    keys = {
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle buffer pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
    },
    opts = function()
      local severity_labels = { error = "E:", warning = "W:", info = "I:", hint = "H:" }

      return {
        options = {
          always_show_bufferline = false,
          show_close_icon = false,
          show_buffer_close_icons = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = severity_labels.hint
            if level:match "error" then
              icon = severity_labels.error
            elseif level:match "warn" then
              icon = severity_labels.warning
            elseif level:match "info" then
              icon = severity_labels.info
            end
            return icon .. count
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
          hover = {
            enabled = true,
            delay = 150,
            reveal = { "close" },
          },
          separator_style = vim.g.have_nerd_font and "slant" or "thin",
          indicator = vim.g.have_nerd_font and { style = "icon" } or { style = "underline" },
          show_buffer_icons = vim.g.have_nerd_font,
        },
      }
    end,
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
