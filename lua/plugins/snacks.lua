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

local function toggle_scratch()
  require('snacks').scratch()
end

local function select_scratch()
  require('snacks').scratch.select()
end

return {
  {
    'folke/snacks.nvim',
    lazy = false,
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
      {
        '<leader>ps',
        toggle_scratch,
        desc = '[P]ad [S]cratch toggle',
      },
      {
        '<leader>pS',
        select_scratch,
        desc = '[P]ad pick [S]cratch',
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
      scratch = {
        enabled = true,
        filekey = {
          cwd = true,
          branch = true,
          count = true,
        },
        win = {
          style = 'scratch',
        },
      },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 12, total = 200 },
          easing = 'inOutSine',
        },
        animate_repeat = {
          delay = 100,
          duration = { step = 6, total = 60 },
          easing = 'outSine',
        },
      },
      words = {
        enabled = true,
        debounce = 100,
        notify_jump = true,
        filter = function(buf)
          local bt = vim.bo[buf].buftype
          if bt ~= '' then
            return false
          end
          local ft = vim.bo[buf].filetype
          if ft == 'help' or ft == 'snacks_terminal' then
            return false
          end
          return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
        end,
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
        scratch = {
          position = 'float',
          width = 0.7,
          height = 0.6,
          border = 'rounded',
          title = ' Scratch ',
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
    end,
  },
}
