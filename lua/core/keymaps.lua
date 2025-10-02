-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show [d]iagnostic [e]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window management keybinds (Windows-style with SPC prefix)
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>w/', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch windows' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>wL', '<C-w>L', { desc = 'Move window to right' })
vim.keymap.set('n', '<leader>wH', '<C-w>H', { desc = 'Move window to left' })
vim.keymap.set('n', '<leader>wJ', '<C-w>J', { desc = 'Move window to lower' })
vim.keymap.set('n', '<leader>wK', '<C-w>K', { desc = 'Move window to upper' })


-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete single character without copying into register' })

-- Recent files mapping
vim.keymap.set('n', '<leader>fr', function()
  require('telescope.builtin').oldfiles()
end, { desc = '[F]ile [r]ecent' })-- Confirm quit all; warns about unsaved buffers
vim.keymap.set('n', '<leader>qq', '<cmd>confirm qa<CR>', {
  desc = '[Q]uit all (confirm)',
})
