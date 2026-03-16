local function has_magic(str)
  return str:find('[%^%$%[%]().%*%+%-%?]') ~= nil
end

local function type_matches(node_type, patterns)
  if not node_type then
    return false
  end
  node_type = node_type:lower()
  for _, pattern in ipairs(patterns) do
    local pat = pattern:lower()
    if node_type == pat then
      return true
    end
    if has_magic(pat) then
      if node_type:match(pat) then
        return true
      end
    elseif node_type:find(pat, 1, true) then
      return true
    end
  end
  return false
end

local function treesitter_operation(lhs, desc, patterns)
  return {
    lhs,
    mode = { 'n', 'x', 'o' },
    function()
      require('flash').treesitter {
        matcher = function(win, state)
          local labels = state:labels()
          local matches = {}
          local ts = require('flash.plugins.treesitter')
          local buf = vim.api.nvim_win_get_buf(win)
          local line_count = vim.api.nvim_buf_line_count(buf)
          for _, match in ipairs(ts.get_nodes(win, state.pos)) do
            local start_row = match.pos and match.pos[1] or 0
            local end_row = match.end_pos and match.end_pos[1] or 0
            if start_row >= 1
              and start_row <= line_count
              and end_row >= 1
              and end_row <= line_count
              and type_matches(match.node and match.node:type(), patterns)
            then
              if labels and #labels > 0 then
                match.label = table.remove(labels, 1)
              else
                match.label = nil
              end
              matches[#matches + 1] = match
            end
          end

          local count = #matches
          for index, item in ipairs(matches) do
            item.first = index == 1
            item.depth = count - index
          end

          return matches
        end,
      }
    end,
    desc = desc,
  }
end

local function gather_normal_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative == '' then
        local bufnr = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == '' then
          name = '[No Name]'
        else
          name = vim.fn.fnamemodify(name, ':t')
        end
        wins[#wins + 1] = {
          win = win,
          number = vim.api.nvim_win_get_number(win),
          name = name,
        }
      end
    end
  end

  table.sort(wins, function(a, b)
    return a.number < b.number
  end)

  return wins
end

local function jump_to_window()
  local wins = gather_normal_windows()
  if #wins <= 1 then
    vim.notify('Only one window available', vim.log.levels.INFO)
    return
  end

  vim.ui.select(wins, {
    prompt = 'Jump to window',
    format_item = function(item)
      return string.format('%d  %s', item.number, item.name)
    end,
  }, function(choice)
    if choice and vim.api.nvim_win_is_valid(choice.win) then
      vim.api.nvim_set_current_win(choice.win)
    end
  end)
end

return {
  -- Jump operations
  {
    'folke/flash.nvim',
    keys = {
      {
        '<leader>jw',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Jump to word',
      },
      {
        '<leader>jt',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Jump to treesitter node',
      },
      {
        '<leader>jf',
        mode = 'n',
        jump_to_window,
        desc = 'Jump (focus) window',
      },
      treesitter_operation(
        '<leader>jtf',
        'Treesitter function/method',
        {
          'function',
          'method',
          'lambda',
          'closure',
          'arrow_function',
        }
      ),
      treesitter_operation(
        '<leader>jtc',
        'Treesitter class/struct',
        {
          'class',
          'struct',
          'interface',
          'impl',
          'trait',
          'enum',
          'object',
          'namespace',
          'module',
        }
      ),
      treesitter_operation(
        '<leader>jtb',
        'Treesitter loop/conditional',
        {
          'if',
          'switch',
          'case',
          'when',
          'for',
          'while',
          'loop',
          'repeat',
          'match',
          'conditional',
        }
      ),
      {
        '<leader>jr',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote flash',
      },
      {
        '<leader>jR',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter search',
      },
      {
        '<leader>jl',
        "<cmd>lua vim.ui.input({ prompt = 'Go to line: ' }, function(input) if input then vim.cmd('normal! ' .. input .. 'G') end end)<cr>",
        desc = 'Jump to line',
      },
    },
    config = function()
      local flash = require('flash')
      local flash_config = {
        -- Labels to use for flash jumps
        labels = 'asdfghjklqwertyuiopzxcvbnm',
        search = {
          -- Show search in command line
          mode = 'exact',
          -- Maximum number of search results
          max_length = false,
        },
        jump = {
          -- Save location in jumplist
          jumplist = true,
          -- Jump position
          pos = 'start',
          -- Clear highlight after jump
          history = false,
          register = false,
        },
        label = {
          -- Allow uppercase labels
          uppercase = true,
          -- Show labels after pattern
          after = true,
          before = true,
          -- Label style
          style = 'overlay',
        },
        highlight = {
          -- Highlight settings
          backdrop = true,
          matches = true,
          priority = 5000,
        },
        -- Treesitter mode configuration
        modes = {
          search = {
            enabled = true,
          },
          char = {
            enabled = true,
            jump_labels = true,
          },
          treesitter = {
            labels = 'abcdefghijklmnopqrstuvwxyz',
            jump = { pos = 'range' },
            search = { incremental = false },
            label = { before = true, after = true, style = 'inline' },
            highlight = {
              backdrop = false,
              matches = false,
            },
          },
        },
      }

      flash.setup(flash_config)

      local flash_group = vim.api.nvim_create_augroup('VisualMultiFlash', { clear = true })
      local function toggle_flash_char(enabled)
        if flash_config.modes.char.enabled == enabled then
          return
        end
        flash_config.modes.char.enabled = enabled
        flash.setup(flash_config)
      end

      vim.api.nvim_create_autocmd('User', {
        group = flash_group,
        pattern = 'visual_multi_start',
        callback = function()
          toggle_flash_char(false)
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        group = flash_group,
        pattern = 'visual_multi_exit',
        callback = function()
          toggle_flash_char(true)
        end,
      })
    end,
  },

  -- Jump to changes
  {
    'nvim-lua/plenary.nvim',
    keys = {
      { '<leader>jC', 'g;', desc = 'Jump to previous change' },
      { '<leader>jc', 'g,', desc = 'Jump to next change' },
    },
  },

  -- Enhanced f/F movement with unique indicators
  {
    'jinh0/eyeliner.nvim',
    config = function()
      local eyeliner = require('eyeliner')
      local eyeliner_config = {
        highlight_on_key = true,
        dim = true,
        max_length = 9999,
        disabled_filetypes = {
          'neo-tree',
          'snacks_terminal',
          'help',
          'oil',
          'trouble',
        },
        disabled_buftypes = {
          'nofile',
          'terminal',
          'quickfix',
        },
        default_keymaps = true,
      }

      local function set_eyeliner_keymaps(enabled)
        if eyeliner_config.default_keymaps == enabled then
          return
        end
        eyeliner_config.default_keymaps = enabled
        eyeliner.setup(eyeliner_config)
      end

      eyeliner.setup(eyeliner_config)

      local eyeliner_group = vim.api.nvim_create_augroup('VisualMultiEyeliner', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = eyeliner_group,
        pattern = 'visual_multi_start',
        callback = function()
          set_eyeliner_keymaps(false)
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        group = eyeliner_group,
        pattern = 'visual_multi_exit',
        callback = function()
          set_eyeliner_keymaps(true)
        end,
      })
    end,
  },
}
