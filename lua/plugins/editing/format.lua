return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>cf',
        function()
          local opts = { async = true, lsp_fallback = true }
          local mode = vim.fn.mode()
          if mode == 'v' or mode == 'V' or mode == '\22' then
            local regions = vim.fn.getregionpos(vim.fn.getpos 'v', vim.fn.getpos '.', {
              type = mode,
              exclusive = vim.o.selection == 'exclusive',
            })
            local first, last = regions[1][1], regions[#regions][2]
            local line = vim.api.nvim_buf_get_lines(0, last[2] - 1, last[2], true)[1]
            local start_col, end_col = 0, #line
            if mode == 'v' then
              start_col = first[3] - 1
              -- Convert the inclusive byte position to an exclusive range end.
              end_col = last[3] - 1 + #vim.fn.strcharpart(line:sub(last[3]), 0, 1)
            end
            -- Linewise and block selections format their covered lines.
            opts.range = { start = { first[2], start_col }, ['end'] = { last[2], end_col } }
          end
          require('conform').format(opts)
        end,
        mode = { 'n', 'x' },
        desc = '[C]ode [F]ormat buffer or selection',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
