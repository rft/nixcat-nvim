-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Esc>', function()
  local ok, hlslens = pcall(require, 'hlslens')
  if ok then
    hlslens.stop()
  end
  vim.cmd.nohlsearch()
end, { desc = 'Clear search highlighting' })

-- Diagnostic keymaps
local function diag_jump(count, severity)
  return function()
    vim.diagnostic.jump { count = count, float = true, severity = severity }
  end
end

vim.keymap.set('n', '[d', diag_jump(-1), { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', diag_jump(1), { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>ce', diag_jump(1), { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>cE', diag_jump(-1), { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']e', diag_jump(1, vim.diagnostic.severity.ERROR), { desc = 'Next error' })
vim.keymap.set('n', '[e', diag_jump(-1, vim.diagnostic.severity.ERROR), { desc = 'Previous error' })
vim.keymap.set('n', ']w', diag_jump(1, vim.diagnostic.severity.WARN), { desc = 'Next warning/spell issue' })
vim.keymap.set('n', '[w', diag_jump(-1, vim.diagnostic.severity.WARN), { desc = 'Previous warning/spell issue' })
vim.keymap.set('n', ']h', diag_jump(1, vim.diagnostic.severity.HINT), { desc = 'Next hint/spell issue' })
vim.keymap.set('n', '[h', diag_jump(-1, vim.diagnostic.severity.HINT), { desc = 'Previous hint/spell issue' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show [d]iagnostic [e]rror messages' })
vim.keymap.set('n', '<leader>cx', vim.diagnostic.open_float, { desc = 'LSP diagnostics' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostics to [q]uickfix list' })

-- Comment toggling via the builtin gc operator (ts-comments.nvim enhances it)
vim.keymap.set('n', '<leader>;', 'gcc', { remap = true, desc = 'Comment out line' })
vim.keymap.set('x', '<leader>;', 'gc', { remap = true, desc = 'Comment out lines' })

-- Code utility keymaps
vim.keymap.set('n', '<leader>cc', '<cmd>make<cr>', { desc = 'Compile' })
vim.keymap.set('n', '<leader>cw', function()
  vim.cmd [[%s/\s\+$//e]]
end, { desc = 'Remove trailing whitespace' })
vim.keymap.set('n', '<leader>cW', function()
  vim.cmd [[%s/\n\+\%$//e]]
end, { desc = 'Remove trailing newlines' })

-- Exit terminal mode in the builtin terminal with a single <Esc> (instead of <C-\><C-n>)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window management keybinds (Windows-style with SPC prefix)
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>w/', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = 'Split window horizontally' })
-- :confirm prompts to save/discard when the buffer is modified (e.g. orgmode
-- capture buffers use bufhidden=wipe, so a plain <C-w>c errors with E37)
vim.keymap.set('n', '<leader>wc', '<cmd>confirm close<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch windows' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>wL', '<C-w>L', { desc = 'Move window to right' })
vim.keymap.set('n', '<leader>wH', '<C-w>H', { desc = 'Move window to left' })
vim.keymap.set('n', '<leader>wJ', '<C-w>J', { desc = 'Move window to lower' })
vim.keymap.set('n', '<leader>wK', '<C-w>K', { desc = 'Move window to upper' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = 'Keep only current window' })

local zoom_state = {
  win = nil,
}

local function zoom_equalize()
  if zoom_state.win then
    zoom_state.win = nil
    if #vim.api.nvim_list_wins() > 1 then
      pcall(vim.cmd, 'wincmd =')
    end
  end
end

local function toggle_window_focus()
  local current = vim.api.nvim_get_current_win()
  if zoom_state.win and vim.api.nvim_win_is_valid(zoom_state.win) then
    if zoom_state.win == current then
      zoom_equalize()
      return
    else
      zoom_equalize()
    end
  end

  zoom_state.win = current
  vim.cmd 'wincmd |'
  vim.cmd 'wincmd _'
end

vim.api.nvim_create_autocmd('WinClosed', {
  desc = 'Equalize windows when closing a zoomed split',
  callback = function(event)
    if zoom_state.win and tonumber(event.match) == zoom_state.win then
      zoom_equalize()
    end
  end,
})

vim.keymap.set('n', '<leader>wm', toggle_window_focus, { desc = 'Toggle focused window' })

local function current_file_path(kind)
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    return nil, 'Current buffer has no associated file'
  end

  local modifier
  if kind == 'relative' then
    modifier = ':~:.'
  else
    modifier = ':p'
  end

  local path = vim.fn.fnamemodify(bufname, modifier)
  return path, nil
end

local function copy_file_path(kind)
  local path, err = current_file_path(kind)
  if not path then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  local ok = pcall(vim.fn.setreg, '+', path)
  local label = kind == 'relative' and 'Relative' or 'Absolute'
  local message = string.format('%s path: %s', label, path)
  if ok then
    vim.notify('Copied ' .. message, vim.log.levels.INFO)
  else
    vim.notify(message .. ' (clipboard unavailable)', vim.log.levels.INFO)
  end
end

local function open_in_file_manager()
  local path, err = current_file_path 'absolute'
  local target
  if not path then
    target = vim.fn.getcwd()
  else
    target = path
  end

  local function is_wsl()
    if vim.fn.has 'wsl' == 1 then
      return true
    end
    local ok, uname = pcall(vim.uv.os_uname)
    return ok and uname and uname.release and uname.release:lower():find('microsoft', 1, true) ~= nil
  end

  local running_wsl = is_wsl()

  if not running_wsl then
    local ok, ui_err = pcall(vim.ui.open, target)
    if ok then
      return
    elseif ui_err then
      vim.notify('vim.ui.open failed: ' .. ui_err, vim.log.levels.WARN)
    end
  end

  local function to_windows_path(p)
    if p == nil or p == '' then
      return nil
    end
    if vim.fn.executable 'wslpath' ~= 1 then
      return nil
    end
    local win_path = vim.fn.system { 'wslpath', '-w', p }
    if vim.v.shell_error ~= 0 then
      return nil
    end
    return vim.trim(win_path)
  end

  local cmd
  if vim.fn.has 'mac' == 1 and vim.fn.executable 'open' == 1 then
    if err then
      cmd = { 'open', target }
    else
      cmd = { 'open', '-R', target }
    end
  elseif (vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1) and vim.fn.executable 'cmd.exe' == 1 then
    local dir = err and target or vim.fn.fnamemodify(target, ':h')
    cmd = { 'cmd.exe', '/C', 'start', '', dir }
  elseif running_wsl then
    local explorer = nil
    if vim.fn.executable 'explorer.exe' == 1 then
      explorer = 'explorer.exe'
    elseif vim.fn.executable '/mnt/c/Windows/explorer.exe' == 1 then
      explorer = '/mnt/c/Windows/explorer.exe'
    end

    if explorer then
      local dir = err and target or vim.fn.fnamemodify(target, ':h')
      local win_dir = to_windows_path(dir)
      if win_dir and win_dir ~= '' then
        cmd = { explorer, win_dir }
      end
    end
  elseif vim.fn.executable 'xdg-open' == 1 then
    local dir = err and target or vim.fn.fnamemodify(target, ':h')
    cmd = { 'xdg-open', dir }
  end

  if not cmd then
    vim.notify('No system file manager command available to open ' .. target, vim.log.levels.ERROR)
    return
  end

  local ok = vim.fn.jobstart(cmd, { detach = true })
  if ok <= 0 then
    vim.notify('Failed to open file manager for ' .. target, vim.log.levels.ERROR)
  end
end

vim.keymap.set('n', '<leader>fp', function()
  copy_file_path 'absolute'
end, { desc = '[F]ile copy absolute [p]ath' })

vim.keymap.set('n', '<leader>fP', function()
  copy_file_path 'relative'
end, { desc = '[F]ile copy relative [P]ath' })

vim.keymap.set('n', '<leader>fe', open_in_file_manager, { desc = '[F]ile open in system [e]xplorer' })

vim.keymap.set('n', '<leader>fs', '<cmd>w<cr>', { desc = '[F]ile [s]ave' })

-- LSP formatting; <leader>cf (conform) is the formatter-aware variant
vim.keymap.set('n', '<leader>fm', function()
  vim.lsp.buf.format()
end, { desc = '[F]ormat [m]arkup/code' })
vim.keymap.set('v', '<leader>fm', function()
  vim.lsp.buf.format()
end, { desc = '[F]ormat region' })

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete single character without copying into register' })

-- Confirm quit all; warns about unsaved buffers
vim.keymap.set('n', '<leader>qq', '<cmd>confirm qa<CR>', {
  desc = '[Q]uit all (confirm)',
})
