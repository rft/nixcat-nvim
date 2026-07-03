-- Dynamic mode-based highlights
-- https://github.com/rasulomaroff/reactive.nvim

local nixCatsUtils = require 'nixCatsUtils'
local nixCats = _G.nixCats

local function resolve_plugin_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local candidates = { 'reactive-nvim', 'reactive.nvim', 'reactive' }

  for _, name in ipairs(candidates) do
    local start_path = nixCats.pawsible { 'allPlugins', 'start', name }
    if type(start_path) == 'string' and start_path ~= '' then
      return start_path
    end

    local opt_path = nixCats.pawsible { 'allPlugins', 'opt', name }
    if type(opt_path) == 'string' and opt_path ~= '' then
      return opt_path
    end
  end

  return nil
end

local function build_spec(source)
  local spec = {
    lazy = false,
    config = function()
      -- Reactive redraws on win/mode events; while a snacks picker is open
      -- (prompt input + transient preview mode flips) that :redraw clamps the
      -- insert-mode cursor in the picker input one cell left, so skip all
      -- prompt/snacks contexts.
      local function skip_reactive()
        if vim.bo.buftype == 'prompt' or vim.bo.filetype:find '^snacks_' then
          return true
        end
        local ok, pickers = pcall(function()
          return Snacks.picker.get()
        end)
        return ok and pickers ~= nil and #pickers > 0
      end

      require('reactive').setup {
        builtin = {
          cursorline = { skip = skip_reactive },
          cursor = { skip = skip_reactive },
          modemsg = { skip = skip_reactive },
        },
      }

      -- The skip above empties the snapshots, but stripping highlights the
      -- main window carried into a picker (e.g. picker.lines previews in the
      -- main window) still triggers reactive's forced :redraw — same clamp.
      -- Suppress the redraw itself in skip contexts; the strip shows up on
      -- the next natural redraw.
      local Highlight = require 'reactive.highlight'
      local orig_apply = Highlight.apply
      Highlight.apply = function(self, opts)
        if not skip_reactive() then
          return orig_apply(self, opts)
        end
        vim.cmd.redraw = function() end
        local ok, err = pcall(orig_apply, self, opts)
        vim.cmd.redraw = nil -- restore vim.cmd's metatable dispatch
        if not ok then
          error(err)
        end
      end
    end,
  }

  if source.dir then
    spec.dir = source.dir
    spec.name = 'reactive.nvim'
  else
    spec[1] = source.repo
  end

  return spec
end

local plugin_path = resolve_plugin_path()

if not plugin_path then
  return {}
end

return { build_spec { dir = plugin_path } }
