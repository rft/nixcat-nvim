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
      require('flash').setup {
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
      require('eyeliner').setup {
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
    end,
  },
}
