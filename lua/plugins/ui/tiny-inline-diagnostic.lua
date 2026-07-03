return {
  { -- Show diagnostics inline instead of virtual text at end of line
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    opts = {
      signs = {
        left = '',
        right = '',
        diag = '●',
        arrow = '    ',
        up_arrow = '    ',
        vertical = ' │',
        vertical_end = ' └',
      },
      blend = {
        factor = 0.27,
      },
      options = {
        -- Show the source of the diagnostic
        show_source = false,
        -- Throttle the update of the diagnostic
        throttle = 20,
        -- Only show ERROR, WARN, INFO (excludes HINT/spelling)
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
        },
        softwrap = 15,
        -- Use multiline messages
        multilines = {
          enabled = true,
          always_show = true,
          trim_whitespaces = false,
          tabstop = 4,
          -- Multiline diagnostics bypass the top-level severity filter,
          -- so exclude HINT/spelling here as well
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
          },
        },
        -- Show all diagnostics on the line
        show_all_diags_on_cursorline = true,
        -- Enable diagnostic on insert mode
        enable_on_insert = true,
      },
    },
  },
}
