-- Bootstrap for this nixCats + lazy.nvim configuration.
--
-- Core options and keymaps live in lua/core/, plugin specs live in
-- lua/plugins/ organized by category (see docs/plugins.md).
-- Originally based on kickstart.nvim.

-- NOTE: nixCats: this gives the nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- It is very useful for passing info from nix to lua, so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}
require 'core.keymaps'
require 'core.options'

-- NOTE: nixCats: we asked nix if we have a nerd font instead of setting it here,
-- because nix is more likely to know if we have one or not.
vim.g.have_nerd_font = nixCats 'have_nerd_font'

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- NOTE: nixCats: the nix store is read-only, so keep the lockfile
-- somewhere writable when nix manages the config.
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end

local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- [[ Configure and install plugins ]]
--  Check plugin status with :Lazy (press `?` for help, `:q` to close).
--
-- NOTE: nixCats: this is the lazy wrapper. Use it like require('lazy').setup()
-- but with an extra first argument: the path to lazy.nvim as downloaded by nix,
-- or nil, before the normal arguments.
--
-- Subdirectories of lua/plugins/ must be imported explicitly
-- (lazy.nvim does not recurse).
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  { import = 'plugins' },
  { import = 'plugins.ui' },
  { import = 'plugins.navigation' },
  { import = 'plugins.editing' },
  { import = 'plugins.lsp' },
  { import = 'plugins.git' },
  { import = 'plugins.tools' },
  { import = 'plugins.neorg' },
  { import = 'plugins.obsidian' },
}, lazyOptions)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
