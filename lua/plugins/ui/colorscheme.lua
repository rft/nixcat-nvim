return {
  {
    -- If you want to see what colorschemes are already installed, you can use `:lua Snacks.picker.colorschemes()`.
    'navarasu/onedark.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      require('onedark').setup {
        style = 'warmer',
      }
      vim.cmd.colorscheme 'onedark'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
