local function diagnostics_segment(bufnr)
  local severities = {
    { level = vim.diagnostic.severity.ERROR, icon = '', group = 'DiagnosticError' },
    { level = vim.diagnostic.severity.WARN, icon = '', group = 'DiagnosticWarn' },
    { level = vim.diagnostic.severity.INFO, icon = '', group = 'DiagnosticInfo' },
    { level = vim.diagnostic.severity.HINT, icon = '', group = 'DiagnosticHint' },
  }

  for _, severity in ipairs(severities) do
    local count = #vim.diagnostic.get(bufnr, { severity = severity.level })
    if count > 0 then
      return { ' ' .. severity.icon .. ' ' .. count, group = severity.group }
    end
  end
end

return {
  {
    'b0o/incline.nvim',
    event = 'BufReadPre',
    config = function()
      local incline = require 'incline'
      local has_devicons, devicons = pcall(require, 'nvim-web-devicons')

      incline.setup {
        debounce_threshold = { falling = 50, rising = 10 },
        ignore = {
          buftypes = { 'nofile', 'prompt', 'quickfix' },
          filetypes = {
            'neo-tree',
            'oil',
            'toggleterm',
            'dap-repl',
            'dapui_breakpoints',
            'dapui_scopes',
            'dapui_stacks',
            'dapui_watches',
          },
        },
        highlight = {
          groups = {
            InclineNormal = 'CursorLine',
            InclineNormalNC = 'CursorLineNr',
          },
        },
        window = {
          margin = { vertical = 0, horizontal = 1 },
          padding = 1,
          placement = { vertical = 'top', horizontal = 'right' },
          options = {
            signcolumn = 'no',
            wrap = false,
          },
        },
        render = function(props)
          local buf = props.buf
          local filename = vim.api.nvim_buf_get_name(buf)
          filename = filename ~= '' and vim.fn.fnamemodify(filename, ':t') or '[No Name]'

          local segments = {}

          if has_devicons then
            local icon, color = devicons.get_icon_color(filename, nil, { default = true })
            if icon then
              table.insert(segments, { icon, guifg = color, gui = 'bold' })
            end
          end

          local modified = vim.bo[buf].modified and ' ●' or ''
          local readonly = (not vim.bo[buf].modifiable or vim.bo[buf].readonly) and ' ' or ''

          table.insert(segments, { ' ' .. filename .. modified .. readonly })

          local diag = diagnostics_segment(buf)
          if diag then
            table.insert(segments, diag)
          end

          return segments
        end,
      }
    end,
  },
}
