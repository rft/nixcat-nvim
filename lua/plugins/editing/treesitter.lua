return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    -- NOTE: nixCats: nixpkgs ships the main-branch rewrite of nvim-treesitter
    -- together with every grammar (withAllGrammars), so there is nothing to
    -- install or update at runtime.
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      require('nvim-treesitter').setup {}

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
