local split_terminal

local function toggle_float_terminal()
  -- Use configured default terminal instance (float)
  require('snacks').terminal()
end

local function toggle_split_terminal()
  local snacks = require 'snacks'
  if not split_terminal or not split_terminal:buf_valid() then
    split_terminal = snacks.terminal.open(nil, {
      win = {
        style = 'terminal',
        position = 'bottom',
        height = 15,
        enter = true,
      },
    })
    split_terminal:on('BufWipeout', function()
      split_terminal = nil
    end, { buf = true })
  else
    split_terminal:toggle()
  end
end

local function git_blame_line_with_count()
  local count = vim.v.count > 0 and vim.v.count or nil
  require('snacks').git.blame_line { count = count }
end

return {
  {
    'folke/snacks.nvim',
    keys = {
      { '<leader>ot', toggle_float_terminal, desc = 'Toggle terminal' },
      {
        '<leader>os',
        toggle_split_terminal,
        desc = 'Toggle split terminal',
        mode = { 'n', 't' },
      },
      {
        '<leader>gB',
        function()
          require('snacks').gitbrowse()
        end,
        desc = '[G]it open in [B]rowser',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gl',
        git_blame_line_with_count,
        desc = '[G]it blame [L]ine history',
      },
    },
    opts = {
      gitbrowse = { enabled = true },
      git = { enabled = true },
      terminal = {
        enabled = true,
        win = {
          style = 'terminal',
          position = 'float',
        },
      },
      styles = {
        blame_line = {
          width = 0.7,
          height = 0.7,
          border = 'rounded',
        },
        terminal = {
          position = 'float',
          height = 0.85,
          width = 0.9,
          border = 'rounded',
          backdrop = 40,
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
    end,
  },
}
