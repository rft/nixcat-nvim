return {
  {
    'jpalardy/vim-slime',
    keys = {
      { '<leader>cl', '<cmd>SlimeSendCurrentLine<cr>', desc = 'Send current line to Slime' },
      { '<leader>cr', '<cmd>SlimeSend<cr>', mode = 'v', desc = 'Send selection to Slime' },
      { '<leader>cc', '<cmd>SlimeConfig<cr>', desc = 'Slime target config' },
    },
    init = function()
      vim.g.slime_target = 'zellij'
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_dont_ask_default = 0
      vim.g.slime_cell_delimiter = '# %%'
    end,
  },
}
