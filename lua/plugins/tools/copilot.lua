local nixCatsUtils = require('nixCatsUtils')
local nixCats = _G.nixCats

local function resolve_copilot_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local start_path = nixCats.pawsible { 'allPlugins', 'start', 'copilot-vim' }
  if type(start_path) == 'string' and start_path ~= '' then
    return start_path
  end

  local opt_path = nixCats.pawsible { 'allPlugins', 'opt', 'copilot-vim' }
  if type(opt_path) == 'string' and opt_path ~= '' then
    return opt_path
  end

  return nil
end

local function build_spec(source)
  local spec = {
    event = 'InsertEnter',
    config = function()
      -- Disable default Copilot mapping so we can provide our own
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      -- Disable Copilot for transient buffers that should never get AI completion
      vim.g.copilot_filetypes = {
        TelescopePrompt = false,
        ['neo-tree'] = false,
        lazy = false,
        oil = false,
      }

      -- Accept suggestions with <Tab>, prioritising Sidekick NES before inline ghosts
      vim.keymap.set('i', '<Tab>', function()
        local sidekick_ok, sidekick = pcall(require, 'sidekick')
        if sidekick_ok and sidekick.nes_jump_or_apply() then
          return ''
        end

        local fallback = vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
        return vim.fn['copilot#Accept'](fallback)
      end, {
        expr = true,
        replace_keycodes = false,
        desc = 'Accept Copilot / Sidekick suggestion',
      })

      -- Toggle Copilot per-buffer
      vim.keymap.set('n', '<leader>cT', '<cmd>Copilot toggle<CR>', { desc = 'Copilot toggle buffer' })
    end,
  }

  if source.dir then
    spec.dir = source.dir
    spec.name = 'copilot.vim'
  else
    spec[1] = source.repo
  end

  return spec
end

local copilot_path = resolve_copilot_path()

if copilot_path then
  return { build_spec { dir = copilot_path } }
end

-- Fallback for non-nix usage
return { build_spec { repo = 'github/copilot.vim' } }
