return {
  {
    'lewis6991/satellite.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('satellite').setup {
        current_only = false,
        winblend = 20,
        zindex = 40,
        width = 2,
        excluded_filetypes = { 'neo-tree', 'oil', 'help', 'lazy', 'mason' },
        handlers = {
          search = { enable = true },
          diagnostic = { enable = true },
          gitsigns = { enable = true },
          marks = { enable = true },
        },
      }
    end,
  },
}
