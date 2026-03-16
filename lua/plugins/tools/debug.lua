-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  -- NOTE: nixCats: return true only if category is enabled, else false
  enabled = require('nixCatsUtils').enableForCategory("kickstart-debug"),
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    -- NOTE: nixCats: dont use mason on nix. We can already download stuff just fine.
    { 'williamboman/mason.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
    { 'jay-babu/mason-nvim-dap.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    local signs = {
      Breakpoint = { text = '', texthl = 'DiagnosticError' },
      BreakpointCondition = { text = '', texthl = 'DiagnosticWarn' },
      BreakpointRejected = { text = '', texthl = 'DiagnosticError' },
      Stopped = { text = '', texthl = 'DiagnosticOk', linehl = 'DiagnosticUnderlineInfo', numhl = 'DiagnosticOk' },
      LogPoint = { text = '', texthl = 'DiagnosticInfo' },
    }
    for name, sign in pairs(signs) do
      vim.fn.sign_define('Dap' .. name, sign)
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'dap-repl', 'dapui_watches', 'dapui_console' },
      callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
      end,
    })

    dap.defaults.fallback.external_terminal = {
      command = vim.o.shell,
      args = { '-c' },
    }

    -- NOTE: nixCats: dont use mason on nix. We can already download stuff just fine.
    if not require('nixCatsUtils').isNixCats then
      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
        },
      }
    end

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '[D]ebug: Set [B]reakpoint' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = '[D]ebug: Run Last' })
    vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = '[D]ebug: Toggle REPL' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug: Continue' })
    vim.keymap.set({ 'n', 'v' }, '<leader>de', function()
      dapui.eval(nil, { enter = true })
    end, { desc = '[D]ebug: Evaluate' })
    vim.keymap.set('n', '<leader>dx', function()
      dap.terminate()
      dapui.close()
    end, { desc = '[D]ebug: Terminate Session' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        element = 'repl',
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.35 },
            { id = 'breakpoints', size = 0.2 },
            { id = 'stacks', size = 0.2 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 0.25,
          position = 'bottom',
        },
      },
      floating = {
        border = 'rounded',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = '[D]ebug: Toggle UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
