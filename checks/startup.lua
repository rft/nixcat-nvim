-- Smoke test run by `nix flake check` (see checks.startup in flake.nix):
-- start the wrapped nvim headless, load every plugin, and fail if anything
-- raised an error along the way.

local problems = {}

local function problem(source, msg)
  problems[#problems + 1] = string.format('[%s] %s', source, tostring(msg))
end

-- Errors raised while init.lua ran, before this script was sourced.
if vim.v.errmsg ~= '' then
  problem('startup', vim.v.errmsg)
end

-- From here on, record error notifications directly: lazy.nvim reports
-- failing plugin configs through vim.notify instead of raising.
local notify = vim.notify
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.ERROR then
    problem('notify', msg)
  end
  return notify(msg, level, opts)
end

-- Load every plugin that has a spec of its own. Plugins that only appear as
-- a dependency are left to their parents, as in normal use (loading e.g. a
-- cmp source on its own would require 'cmp' before nvim-cmp is set up).
local lazy = require 'lazy'
local names = {}
for _, plugin in ipairs(lazy.plugins()) do
  if not plugin._.dep then
    names[#names + 1] = plugin.name
  end
end
table.sort(names)

for _, name in ipairs(names) do
  local ok, err = pcall(lazy.load, { plugins = { name }, wait = true })
  if not ok then
    problem(name, err)
  end
end

-- Give VeryLazy and scheduled callbacks a chance to run (and to fail).
vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazy', modeline = false })
vim.wait(500)

for _, plugin in ipairs(lazy.plugins()) do
  if not plugin._.loaded then
    problem(plugin.name, 'plugin did not load')
  end
end

-- Error notifications that went to the snacks notifier before the hook above
-- was installed.
local ok, history = pcall(function()
  return Snacks.notifier.get_history()
end)
if ok then
  for _, notif in ipairs(history) do
    if notif.level == 'error' then
      problem('notifier', notif.msg)
    end
  end
end

if #problems > 0 then
  -- De-duplicate: the notify hook and the notifier history can overlap.
  local seen = {}
  io.stderr:write 'startup check failed:\n'
  for _, line in ipairs(problems) do
    if not seen[line] then
      seen[line] = true
      io.stderr:write('  ' .. line .. '\n')
    end
  end
  vim.cmd.cquit(1)
end

io.stdout:write(string.format('startup check passed: %d plugins loaded without errors\n', #lazy.plugins()))
