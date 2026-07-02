return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    -- NOTE: nixCats: nixpkgs ships the main-branch rewrite of nvim-treesitter;
    -- match it when lazy.nvim downloads the plugin instead.
    branch = require('nixCatsUtils').lazyAdd 'main',
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = require('nixCatsUtils').lazyAdd 'main',
      },
    },
    config = function()
      require('nvim-treesitter').setup {}

      -- NOTE: nixCats: nix ships withAllGrammars, so installing is only
      -- needed when the plugin was downloaded by lazy.nvim.
      if not require('nixCatsUtils').isNixCats then
        require('nvim-treesitter').install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' }
      end

      -- Enable treesitter highlighting per buffer when filetype is detected
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
