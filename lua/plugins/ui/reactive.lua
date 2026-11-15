-- Dynamic mode-based highlights
-- https://github.com/rasulomaroff/reactive.nvim

return {
  {
    'rasulomaroff/reactive.nvim',
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
  },
}
