-- Small helpers for reading nixCats categories from plugin specs.
-- This config is only ever loaded through nix, so the `nixCats` global
-- (see :help nixCats) is always available.

local M = {}

---Whether a category is enabled. Always returns a boolean, so it is safe to
---use for lazy.nvim's `enabled` field (where `nil` would mean "enabled").
---@param v string|string[]
---@return boolean
function M.enableForCategory(v)
  return nixCats(v) and true or false
end

---The value nix passed for a category, or `default` when it is unset.
---@param v string|string[]
---@param default any
---@return any
function M.getCatOrDefault(v, default)
  local value = nixCats(v)
  if value == nil then
    return default
  end
  return value
end

return M
