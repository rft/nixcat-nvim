-- harpoon
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

-- NOTE: nixCats: harpoon2 is managed by nix, so we just configure it here
if not require('nixCatsUtils').enableForCategory("general") then
  return {}
end

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()

-- Basic telescope configuration for harpoon (optional)
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

-- Keymaps
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "[H]arpoon [a]dd file" })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "[H]arpoon toggle menu" })
vim.keymap.set("n", "<leader>ht", function() toggle_telescope(harpoon:list()) end, { desc = "[H]arpoon [t]elescope" })

-- Navigate to specific files
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "[H]arpoon file [1]" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "[H]arpoon file [2]" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "[H]arpoon file [3]" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "[H]arpoon file [4]" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "[H]arpoon [p]revious" })
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "[H]arpoon [n]ext" })

return {}