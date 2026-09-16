-- Titanium: onedark.nvim re-palletted to match omp's built-in "titanium" theme
-- (packages/coding-agent/src/modes/theme/defaults/titanium.json), so nvim,
-- starship and zellij all read as one scheme.
--
-- onedark supplies the highlight-group coverage (treesitter, LSP, and every
-- plugin here); `colors` swaps its palette and `highlights` fixes the handful
-- of groups where onedark's colour choice disagrees with titanium's.

local titanium = require 'core.palette'

-- onedark wants six background steps and a few muted accents; titanium defines
-- four and no purple. Values marked (derived) extend the ramp or blend an
-- accent toward the editor background -- everything else is verbatim.
local palette = {
  black = titanium.darkTitanium,
  bg_d = titanium.darkTitanium, -- floats, sidebars
  bg0 = titanium.brushedTitanium, -- editor background
  bg1 = titanium.borderMuted, -- cursorline
  bg2 = titanium.subtleGray, -- visual selection
  bg3 = '#343a42', -- (derived) next step past subtleGray
  fg = titanium.brightAluminum,
  grey = titanium.comment,
  light_grey = titanium.dimAluminum,

  red = titanium.alertRed,
  green = titanium.readoutGreen,
  yellow = titanium.warningAmber,
  orange = titanium.warningAmber,
  blue = titanium.electricBlue,
  cyan = titanium.deepBlue,
  purple = titanium.electricBlue, -- titanium has no purple; keywords are blue

  dark_red = '#8c2730', -- (derived) alertRed darkened
  dark_yellow = titanium.titaniumGold,
  dark_cyan = titanium.deepBlue,
  dark_purple = titanium.deepBlue,

  bg_blue = titanium.electricBlue,
  bg_yellow = titanium.titaniumGold,

  diff_add = '#12382f', -- (derived) readoutGreen over bg0
  diff_delete = '#361f28', -- (derived) alertRed over bg0
  diff_change = '#122e3f', -- (derived) electricBlue over bg0
  diff_text = '#0f445e', -- (derived) electricBlue over bg0, stronger
}

-- Groups where onedark's palette slot carries the wrong titanium intent.
-- Left alone because the palette already lands them correctly: keywords and
-- operators (purple -> electricBlue), numbers and constants (orange ->
-- warningAmber), comments (grey), punctuation (light_grey -> dimAluminum),
-- plain variables (fg -> brightAluminum).
local fn = { fg = titanium.readoutGreen } -- syntaxFunction
local str = { fg = titanium.titaniumGold } -- syntaxString
local ty = { fg = titanium.electricBlue } -- syntaxType
local op = { fg = titanium.electricBlue } -- syntaxOperator

local highlights = {
  -- Functions: onedark paints these blue, titanium wants readoutGreen.
  Function = fn,
  ['@function'] = fn,
  ['@function.call'] = fn,
  ['@function.method'] = fn,
  ['@function.method.call'] = fn,
  ['@function.builtin'] = { fg = titanium.readoutGreen, fmt = 'italic' },
  ['@function.macro'] = { fg = titanium.readoutGreen, fmt = 'italic' },
  ['@lsp.type.function'] = fn,
  ['@lsp.type.method'] = fn,

  -- Strings: onedark reuses green, which titanium reserves for success/diffs.
  String = str,
  ['@string'] = str,
  ['@string.documentation'] = str,
  ['@string.special.path'] = str,
  ['@markup.raw'] = str,
  ['@markup.raw.block'] = str,

  -- Types: onedark paints these yellow, which titanium reserves for warnings.
  Type = ty,
  ['@type'] = ty,
  ['@type.definition'] = ty,
  ['@type.builtin'] = { fg = titanium.electricBlue, fmt = 'italic' },
  ['@constructor'] = { fg = titanium.electricBlue, fmt = 'bold' },
  ['@module'] = ty,
  ['@tag.attribute'] = { fg = titanium.titaniumGold },
  ['@lsp.type.class'] = ty,
  ['@lsp.type.struct'] = ty,

  -- Operators: titanium accents them rather than using plain fg.
  Operator = op,
  ['@operator'] = op,

  -- Variables: titanium keeps them aluminium rather than red.
  ['@variable.builtin'] = { fg = titanium.electricBlue, fmt = 'italic' },
  ['@variable.parameter'] = { fg = titanium.dimAluminum },
  ['@variable.member'] = { fg = titanium.brightAluminum },
  ['@property'] = { fg = titanium.brightAluminum },

  -- Markdown headings follow the theme's mdHeading (electricBlue) instead of
  -- onedark's red/purple/orange rotation.
  ['@markup.heading'] = { fg = titanium.electricBlue, fmt = 'bold' },
  ['@markup.heading.1'] = { fg = titanium.electricBlue, fmt = 'bold' },
  ['@markup.heading.2'] = { fg = titanium.electricBlue, fmt = 'bold' },
  ['@markup.heading.3'] = { fg = titanium.deepBlue, fmt = 'bold' },
  ['@markup.heading.4'] = { fg = titanium.deepBlue, fmt = 'bold' },
  ['@markup.heading.5'] = { fg = titanium.dimAluminum, fmt = 'bold' },
  ['@markup.heading.6'] = { fg = titanium.dimAluminum, fmt = 'bold' },
  ['@markup.link'] = { fg = titanium.electricBlue },
  ['@markup.link.url'] = { fg = titanium.deepBlue, fmt = 'underline' },
  ['@markup.quote'] = { fg = titanium.dimAluminum, fmt = 'italic' },

  -- Borders: titanium's border is subtleGray, borderAccent is electricBlue.
  WinSeparator = { fg = titanium.subtleGray },
  FloatBorder = { fg = titanium.subtleGray, bg = titanium.darkTitanium },
  NormalFloat = { fg = titanium.brightAluminum, bg = titanium.darkTitanium },
}

return {
  {
    -- If you want to see what colorschemes are already installed, you can use `:lua Snacks.picker.colorschemes()`.
    'navarasu/onedark.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      require('onedark').setup {
        style = 'darker',
        colors = palette,
        highlights = highlights,
      }
      vim.cmd.colorscheme 'onedark'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
