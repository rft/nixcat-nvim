-- lazy.nvim wrapper from the nixCats luaUtils template, trimmed to the
-- nix-only case: lazy.nvim does the loading, nix provides every plugin.

local M = {}

---Use it like require('lazy').setup(), with the path to the nix-provided
---lazy.nvim as an extra first argument.
---@param nixLazyPath string
---@param lazySpecs any
---@param lazyCFG? table
function M.setup(nixLazyPath, lazySpecs, lazyCFG)
  assert(type(nixLazyPath) == 'string', 'lazy.nvim was not provided by nix; add lazy-nvim to startupPlugins')

  local oldPath
  local lazypatterns
  local fallback
  if type(lazyCFG) == 'table' and type(lazyCFG.dev) == 'table' then
    lazypatterns = lazyCFG.dev.patterns
    fallback = lazyCFG.dev.fallback
    oldPath = lazyCFG.dev.path
  end

  local myNeovimPackages = nixCats.vimPackDir .. '/pack/myNeovimPackages'

  local newLazyOpts = {
    performance = {
      rtp = {
        reset = false,
      },
    },
    install = {
      missing = false,
    },
    checker = {
      enabled = false,
    },
    dev = {
      -- Resolve every plugin by name inside the nix-built pack directory.
      path = function(plugin)
        local path = nil
        if type(oldPath) == 'string' and vim.fn.isdirectory(oldPath .. '/' .. plugin.name) == 1 then
          path = oldPath .. '/' .. plugin.name
        elseif type(oldPath) == 'function' then
          path = oldPath(plugin)
          if type(path) ~= 'string' then
            path = nil
          end
        end
        if path == nil then
          if vim.fn.isdirectory(myNeovimPackages .. '/start/' .. plugin.name) == 1 then
            path = myNeovimPackages .. '/start/' .. plugin.name
          elseif vim.fn.isdirectory(myNeovimPackages .. '/opt/' .. plugin.name) == 1 then
            path = myNeovimPackages .. '/opt/' .. plugin.name
          else
            path = '~/projects/' .. plugin.name
          end
        end
        return path
      end,
      patterns = lazypatterns or { '' },
      fallback = fallback == nil and true or fallback,
    },
  }
  lazyCFG = vim.tbl_deep_extend('force', lazyCFG or {}, newLazyOpts)
  -- do the reset we disabled without removing important stuff
  local cfgdir = nixCats.configDir
  vim.opt.rtp = {
    cfgdir,
    nixCats.nixCatsPath,
    nixCats.pawsible.allPlugins.ts_grammar_path,
    vim.fn.stdpath 'data' .. '/site',
    nixLazyPath,
    vim.env.VIMRUNTIME,
    vim.fn.fnamemodify(vim.v.progpath, ':p:h:h') .. '/lib/nvim',
    cfgdir .. '/after',
  }

  require('lazy').setup(lazySpecs, lazyCFG)
end

return M
