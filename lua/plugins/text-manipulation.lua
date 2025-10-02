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
      { "i", "<Plug>(VM-Visual-Cursors)", mode = "x", desc = "Add cursors to visual selection" },
      { "I", "<Plug>(VM-Visual-Cursors)", mode = "x", desc = "Add cursors to visual selection" },
    },
  },

  -- Word/boolean switcher
  {
    'AndrewRadev/switch.vim',
    keys = {
      { '<leader>cs', '<cmd>Switch<cr>', desc = '[C]ycle [s]witch word' },
      { '<leader>cS', '<cmd>SwitchReverse<cr>', desc = '[C]ycle [S]witch reverse' },
      { '<leader>cs', '<cmd>Switch<cr>', mode = 'v', desc = '[C]ycle [s]witch selection' },
      { '<leader>cS', '<cmd>SwitchReverse<cr>', mode = 'v', desc = '[C]ycle [S]witch reverse selection' },
    },
    init = function()
      vim.g.switch_custom_definitions = {
        { 'true', 'false' },
        { 'True', 'False' },
        { 'TRUE', 'FALSE' },
        { 'yes', 'no' },
        { 'Yes', 'No' },
        { 'on', 'off' },
        { 'On', 'Off' },
        { 'enable', 'disable' },
        { 'Enable', 'Disable' },
        { '&&', '||' },
        { '==', '!=' },
        { 'left', 'right' },
        { 'up', 'down' },
      }
    end,
  },

  -- Markdown and table alignment helpers
  {
    "dhruvasagar/vim-table-mode",
    cmd = { "TableModeToggle", "TableModeEnable", "TableModeDisable", "TableModeRealign" },
    keys = {
      { "<leader>tt", "<cmd>TableModeToggle<cr>", desc = "[T]able [t]oggle" },
      { "<leader>ta", "<cmd>TableModeRealign<cr>", desc = "[T]able re-[a]lign" },
    },
    init = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_disable_mappings = 1
    end,
  },
}
