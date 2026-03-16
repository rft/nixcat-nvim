local nixCatsUtils = require('nixCatsUtils')
local nixCats = _G.nixCats

local fs = vim.uv or vim.loop
local sep = package.config:sub(1, 1)

local function has_colorizer_module(dir)
  if type(dir) ~= 'string' or dir == '' then
    return false
  end

  local candidate_files = {
    table.concat({ dir, 'lua', 'colorizer.lua' }, sep),
    table.concat({ dir, 'lua', 'colorizer', 'init.lua' }, sep),
  }

  for _, file in ipairs(candidate_files) do
    if fs.fs_stat(file) then
      return true
    end
  end

  return false
end

local function plugin_path(names)
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  for _, name in ipairs(names) do
    local start_path = nixCats.pawsible { 'allPlugins', 'start', name }
    if has_colorizer_module(start_path) then
      return start_path
    end

    local opt_path = nixCats.pawsible { 'allPlugins', 'opt', name }
    if has_colorizer_module(opt_path) then
      return opt_path
    end
  end

  return nil
end

local colorizer_path = plugin_path { 'nvim-colorizer.lua', 'nvim-colorizer-lua', 'colorizer' }

if not colorizer_path then
  -- Fall back to letting lazy manage the plugin when not using nixCats
  return {
    {
      'norcalli/nvim-colorizer.lua',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local ok, colorizer = pcall(require, 'colorizer')
        if not ok then
          vim.notify('nvim-colorizer.lua is not available', vim.log.levels.WARN)
          return
        end
        colorizer.setup({
          filetypes = { '*', '!lazy' },
          user_default_options = {
            RGB = true,
            RRGGBB = true,
            names = true,
            RRGGBBAA = true,
            AARRGGBB = true,
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
            tailwind = true,
            mode = 'background',
          },
        })
      end,
    },
  }
end

return {
  {
    dir = colorizer_path,
    name = 'nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local ok, colorizer = pcall(require, 'colorizer')
      if not ok then
        vim.notify('Failed to load nvim-colorizer.lua from nix path: ' .. colorizer_path, vim.log.levels.WARN)
        return
      end
      colorizer.setup({
        filetypes = { '*', '!lazy' },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          tailwind = true,
          mode = 'background',
        },
      })
    end,
  },
}
