return {
  {
    'camgraff/lensline.nvim',
    event = 'BufReadPre',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kevinhwang91/nvim-hlslens',
    },
    config = function()
      local ok, lensline = pcall(require, 'lensline')
      if not ok then
        return
      end

      local function color_from_hl(name, fallback)
        local ok_hl, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if ok_hl and hl then
          if hl.fg then
            return string.format('#%06x', hl.fg)
          end
          if hl.bg then
            return string.format('#%06x', hl.bg)
          end
        end
        return fallback
      end

      local opts = {
        colors = {
          background = color_from_hl('CursorLine', '#1f2335'),
          text = color_from_hl('Normal', '#c0caf5'),
          highlight = color_from_hl('Search', '#bb9af7'),
        },
        separators = {
          left = '',
          right = '',
        },
        sections = {
          left = { 'file', 'modified' },
          middle = { 'lens' },
          right = { 'position', 'percent' },
        },
      }

      local ok_setup = false
      if type(lensline.setup) == 'function' then
        ok_setup = pcall(lensline.setup, opts)
        if not ok_setup then
          pcall(lensline.setup)
        end
      end
    end,
  },
}
