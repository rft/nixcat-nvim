return {
  {
    'catgoose/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('colorizer').setup {
        filetypes = { '*', '!lazy' },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          tailwind = true,
          mode = 'background',
        },
      }
    end,
  },
}
