local split_term

local function toggle_split_terminal()
  local Terminal = require('toggleterm.terminal').Terminal
  if not split_term then
    split_term = Terminal:new {
      id = 2,
      direction = 'horizontal',
      size = 15,
      close_on_exit = true,
      hidden = true,
    }
  end
  split_term:toggle()
end

return {
  -- Terminal toggle
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>ot", "<cmd>ToggleTerm<cr>", desc = "Open terminal" },
      { '<leader>os', toggle_split_terminal, desc = 'Open split terminal', mode = { 'n', 't' } },
    },
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<leader>ot]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },
}
