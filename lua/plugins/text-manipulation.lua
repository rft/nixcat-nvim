return {
  -- Text manipulation - line movement and multicursor
  {
    "matze/vim-move",
    keys = {
      { "<M-k>", "<Plug>MoveLineUp", desc = "Move line up" },
      { "<M-j>", "<Plug>MoveLineDown", desc = "Move line down" },
      { "<M-Up>", "<Plug>MoveLineUp", desc = "Move line up" },
      { "<M-Down>", "<Plug>MoveLineDown", desc = "Move line down" },
      { "<M-k>", "<Plug>MoveBlockUp", mode = "v", desc = "Move selection up" },
      { "<M-j>", "<Plug>MoveBlockDown", mode = "v", desc = "Move selection down" },
      { "<M-Up>", "<Plug>MoveBlockUp", mode = "v", desc = "Move selection up" },
      { "<M-Down>", "<Plug>MoveBlockDown", mode = "v", desc = "Move selection down" },
    },
  },
  
  -- Multi-cursor support
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-M-k>", "<Plug>(VM-Add-Cursor-Up)", desc = "Multicursor add line up" },
      { "<C-M-j>", "<Plug>(VM-Add-Cursor-Down)", desc = "Multicursor add line down" },
      { "<C-M-Up>", "<Plug>(VM-Add-Cursor-Up)", desc = "Multicursor add line up" },
      { "<C-M-Down>", "<Plug>(VM-Add-Cursor-Down)", desc = "Multicursor add line down" },
    },
  },
}