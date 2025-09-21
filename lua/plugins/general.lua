return {
  -- File operations keybinds
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "Open file tree" },
    },
  },
  
  -- Save file keybind
  {
    "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>fs", "<cmd>w<cr>", desc = "Save file" },
    },
  },
}