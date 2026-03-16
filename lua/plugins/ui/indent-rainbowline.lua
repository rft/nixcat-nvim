if not require('nixCatsUtils').enableForCategory 'general' then
  return {}
end

local nixCatsUtils = require 'nixCatsUtils'
local nixCats = _G.nixCats

local function resolve_rainbowline_path()
  if not (nixCatsUtils.isNixCats and nixCats and nixCats.pawsible) then
    return nil
  end

  local candidates = { 'indent-rainbowline-nvim', 'indentRainbowline', 'indent-rainbowline.nvim' }

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

local rainbowline_path = resolve_rainbowline_path()

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      rainbowline_path and { dir = rainbowline_path, name = "indent-rainbowline.nvim" } or "TheGLander/indent-rainbowline.nvim",
    },
    opts = function(_, opts)
      local defaults = {
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help",
            "lazy",
            "mason",
            "neo-tree",
            "oil",
            "Trouble",
            "alpha",
            "dashboard",
            "noice",
            "prompt",
            "spectre_panel",
          },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      }

      opts = vim.tbl_deep_extend("force", defaults, opts or {})

      return require("indent-rainbowline").make_opts(opts, {
        color_transparency = 0.04,
      })
    end,
    keys = {
      {
        "<leader>ti",
        function()
          require("ibl").toggle()
        end,
        desc = "[T]oggle [i]ndent guides",
      },
    },
  },
}
