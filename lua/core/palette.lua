-- omp's built-in "titanium" theme, verbatim from its `vars` block
-- (packages/coding-agent/src/modes/theme/defaults/titanium.json), plus the two
-- `colors` entries that are given as literals rather than var references.
--
-- Shared so the colorscheme and the plugins that hard-code colours all read
-- from one place. See lua/plugins/ui/colorscheme.lua.

local M = {
  brushedTitanium = '#151820', -- editor background (theme's pageBg)
  darkTitanium = '#0f1216', -- floats, sidebars (theme's cardBg)
  electricBlue = '#00b4ff', -- accent
  deepBlue = '#0082b3',
  titaniumGold = '#d4c090',
  brightAluminum = '#e8ecf4',
  dimAluminum = '#9ca3b0',
  warningAmber = '#ffb347',
  readoutGreen = '#00ff88',
  alertRed = '#ff4757',
  subtleGray = '#2a3038', -- borders (theme's infoBg)
  borderMuted = '#1f252d',
  comment = '#6b7280', -- theme's `dim` / `syntaxComment`
}

---Blend a hex colour toward another (default: the editor background).
---Used to derive the muted tints titanium doesn't define outright.
---@param fg string hex colour
---@param alpha number 0..1, share of `fg` in the result
---@param bg? string hex colour to blend into
---@return string hex colour
function M.blend(fg, alpha, bg)
  bg = bg or M.brushedTitanium
  local function parts(hex)
    return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
  end
  local fr, fg_, fb = parts(fg)
  local br, bg_, bb = parts(bg)
  local function mix(a, b)
    return math.floor(alpha * a + (1 - alpha) * b + 0.5)
  end
  return string.format('#%02x%02x%02x', mix(fr, br), mix(fg_, bg_), mix(fb, bb))
end

return M
