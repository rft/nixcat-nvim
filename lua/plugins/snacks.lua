local split_terminal
local scope_enabled = require('nixCatsUtils').enableForCategory 'kickstart-indent_line'

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
    if not split_terminal:win_valid() then
      split_terminal:show()
      split_terminal:focus()
      return
    end

    if vim.api.nvim_get_current_win() == split_terminal.win then
      split_terminal:hide()
    else
      split_terminal:focus()
    end
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
      { '<leader>pn', function() require('snacks').notifier.show_history() end, desc = '[P]opup [N]otifications history' },
      { '<leader>pd', function() require('snacks').dashboard.open() end, desc = '[P]opup [D]ashboard' },
    },
    opts = {
      bigfile = {
        enabled = true,
        notify = true,
        size = 2 * 1024 * 1024,
        line_length = 1500,
        setup = function(ctx)
          if vim.fn.exists(':NoMatchParen') ~= 0 then
            vim.cmd('NoMatchParen')
          end
          Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
          vim.b.minianimate_disable = true
          vim.b.snacks_words = false
          vim.b.snacks_scroll = false
          if pcall(require, 'nvim-treesitter.configs') then
            pcall(vim.treesitter.stop, ctx.buf)
          end
          pcall(function()
            require('illuminate').pause_buf(ctx.buf)
          end)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ctx.buf) then
              vim.bo[ctx.buf].syntax = ctx.ft
            end
          end)
        end,
      },
      gitbrowse = { enabled = true },
      git = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3500,
        level = vim.log.levels.INFO,
        top_down = false,
        margin = { top = 1, right = 1, bottom = 0 },
        style = 'compact',
        date_format = '%H:%M',
        filter = function(notif)
          if notif.title == 'Plugin Loader' then
            return false
          end
          return true
        end,
      },
      dashboard = {
        enabled = true,
        width = 70,
        row = nil,
        col = nil,
        pane_gap = 4,
        preset = {
          header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠠⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⠀⠙⢶⣄⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⣶⣦⣤⣀⣀⣤⣤⣄⣀⠀⢀⣀⣴⠂⠀⠀⠀⠀⠀⠀⠀⠐⠉⠉⣉⣉⣽⣿⣿⣷⣾⣿⣷⣄⡸⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠿⠿⢿⣿⣿⣿⣭⣭⣿⣿⣿⣿⣟⣁⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠶⠤⠀⠀⢠⡾⢿⣿⣿⣿⣿⡿⠉⠀⠀⠀⠈⠙⢻⣿⣿⣿⡛⢻⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠋⠀⠀⠀⠉⠻⣿⣿⣿⣿⣦⡀⠀⠁⠀⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣦⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣯⡙⢦⠀⠀⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡄⠀⠀⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠰⣄⠀⠀⠀⠀⠈⠛⢿⣿⡏⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⡝⡇⠀⠀⠹⡇⠙⢿⣿⣿⣿⣿⣿⣶⣦⣄⣀⣈⣳⣶⣤⣤⣄⣀⠈⠋⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⡇⠁⠀⠀⠀⠙⣠⠤⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡛⠻⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠈⢲⡄⠀⢀⡠⠔⠂⠀⠀⠀⠀⣸⣿⣿⣿⡿⢹⠇⠀⠀⠀⠀⠈⢀⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⡟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣾⣧⣾⣿⣶⣶⣶⣤⣀⠀⠀⣿⣿⣿⣿⠇⠋⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⠟⠛⢿⣿⣿⣿⣿⡄⠀⠻⣿⡿⠿⠛⠛⠛⠛⠿⡿⠀⠀⠀⠀
⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣷⣮⡁⠀⣿⣿⣿⣿⠀⠀⠀⠀⠀⢠⠞⣻⣿⣿⣿⡿⠁⠀⠀⠈⣿⣿⣿⣿⣧⠀⠀⠀⢀⡀⠀⠀⠀⣴⠀⠀⠀⠀⠀⠀
⠀⠀⢠⡿⢹⣿⣿⡋⠀⠈⢻⣿⣿⣿⡟⠆⢻⣿⣿⣿⡇⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⡇⠀⠀⠀⠀⢸⣿⣿⣿⣿⠀⠀⠀⣀⣭⣽⣶⣬⣿⡄⠀⠀⠀⠀⠀
⠀⠀⣰⣷⣿⣿⠿⠃⠀⠀⢸⣿⣿⣿⣿⡄⠘⣿⣿⣿⣿⣄⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⣾⣿⣿⣿⣿⠀⠴⣻⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀
⠀⣴⣿⡿⠋⠀⠀⠀⠀⠀⣼⣿⣿⣿⢿⡇⠀⠘⣿⣿⣿⣿⣦⡀⠀⠀⢸⡟⢿⣿⣿⣿⣿⣧⡀⣰⣿⣿⣿⣿⡏⠀⣼⣿⣿⣿⠋⠀⠉⣿⣿⣌⣷⠀⠀⠀
⠀⠈⠛⠁⠀⠀⠀⠀⠀⢸⣿⣿⣿⡏⠘⠀⠀⠀⠈⢻⣿⣿⣿⣿⣷⣤⡀⠳⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠈⣿⣿⣿⣿⠀⠀⠈⠛⠻⢿⣿⣷⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣷⣶⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⣿⢿⣿⣿⣧⡀⠀⠀⠀⠀⠈⠿⠇⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠘⠌⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣶⣶⣤⣤⣤⣄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⢀⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣀⣤⣤⣴⣾⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⢤⣬⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠠⠾⣿⣿⣿⣶⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣠⣶⣦⣄⡀⠀⠀⣶⢒⠲⣄
⣾⣥⣤⣼⣿⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣵⣾⡿]],
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'g', desc = 'Live Grep', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = ' ', key = 'p', desc = 'Projects', section = 'projects' },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
        sections = {
          { section = 'header', padding = 1 },
          { section = 'keys', gap = 1, padding = 1 },
          {
            pane = 1,
            { section = 'recent_files', title = 'Recently Opened', indent = 2, limit = 5 },
            { section = 'projects', title = 'Projects', indent = 2, padding = 1, limit = 5 },
          },
          { section = 'startup' },
        },
      },
      scope = {
        enabled = scope_enabled,
        debounce = 20,
        siblings = true,
        treesitter = {
          blocks = { enabled = false },
        },
        keys = {
          textobject = {
            ii = { desc = 'inner scope', edge = false, cursor = false },
            ai = { desc = 'around scope', cursor = false },
          },
          jump = {
            ['[i'] = { desc = 'jump to upper scope edge', cursor = false, edge = true },
            [']i'] = { desc = 'jump to lower scope edge', cursor = false, edge = true, bottom = true },
          },
        },
      },
      indent = {
        enabled = scope_enabled,
        indent = {
          char = '│',
          enabled = false,
          only_scope = true,
          hl = {
            'SnacksIndent1',
            'SnacksIndent2',
            'SnacksIndent3',
            'SnacksIndent4',
            'SnacksIndent5',
            'SnacksIndent6',
          },
        },
        scope = {
          enabled = true,
          char = '│',
          underline = true,
          only_current = true,
          hl = {
            'SnacksIndent1',
            'SnacksIndent2',
            'SnacksIndent3',
            'SnacksIndent4',
            'SnacksIndent5',
            'SnacksIndent6',
          },
        },
        animate = {
          enabled = vim.fn.has('nvim-0.10') == 1,
          style = 'out',
          duration = { step = 15, total = 300 },
        },
      },
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
        dashboard = {
          fixbuf = false,
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)

      local function set_snacks_highlights()
        local function hex(name, fallback)
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
          if ok and hl and hl.fg then
            return string.format('#%06x', hl.fg)
          end
          return fallback
        end
        local palette = {
          SnacksIndent1 = { fg = '#E06C75', nocombine = true },
          SnacksIndent2 = { fg = '#E5C07B', nocombine = true },
          SnacksIndent3 = { fg = '#98C379', nocombine = true },
          SnacksIndent4 = { fg = '#56B6C2', nocombine = true },
          SnacksIndent5 = { fg = '#61AFEF', nocombine = true },
          SnacksIndent6 = { fg = '#C678DD', nocombine = true },
          SnacksIndentScope = { fg = hex('Function', '#ffffff'), bold = true, nocombine = true },
        }
        for group, spec in pairs(palette) do
          vim.api.nvim_set_hl(0, group, spec)
        end
      end

      set_snacks_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('snacks-indent-highlights', { clear = true }),
        callback = set_snacks_highlights,
      })
    end,
  },
}
