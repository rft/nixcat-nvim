return {
  -- File operations keybinds
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "[F]ile [t]ree" },
    },
  },
  
  -- Oil file browser
  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>fo", function()
        local oil = require("oil")
        if vim.bo.filetype == "oil" then
          oil.close()
        else
          oil.open()
        end
      end, desc = "[F]ile [o]il browser (toggle)" },
    },
    config = function()
      require("oil").setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        default_file_explorer = true,
        -- Id is automatically added at the beginning, and name at the end
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        -- Buffer-local options to use for oil buffers
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,
        -- Skip the confirmation popup for simple operations (:help oil.skip-confirm)
        skip_confirm_for_simple_edits = false,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        prompt_save_on_select_new_entry = true,
        -- Oil will automatically delete hidden buffers after this delay
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          -- Time to wait for LSP file operations to complete before skipping
          timeout_ms = 1000,
          -- Set to true to autosave buffers that are updated with LSP willRenameFiles
          autosave_changes = false,
        },
        -- Constrain the cursor to the editable parts of the oil buffer
        constrain_cursor = "editable",
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = false,
          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { "type", "asc" },
            { "name", "asc" },
          },
        },
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
        -- Configuration for the actions floating preview window
        preview = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = {40, 0.4},
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          max_height = 0.9,
          min_height = {5, 0.1},
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating progress window
        progress = {
          max_width = 0.9,
          min_width = {40, 0.4},
          width = nil,
          max_height = {10, 0.9},
          min_height = {5, 0.1},
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
      })
    end,
  },
  
  -- File search (primary keybinding)
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[F]ind [f]iles" },
      { "<leader>of", "<cmd>Telescope find_files<cr>", desc = "[O]pen [f]ile" },
    },
  },

  -- Undotree
  {
    "mbbill/undotree",
    keys = {
      { "<leader>ou", "<cmd>UndotreeToggle<cr>", desc = "[O]pen [u]ndo tree" },
    },
    config = function()
      -- Configure undotree
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_DiffCommand = "diff"
      vim.g.undotree_DiffpanelHeight = 10
      vim.g.undotree_HelpLine = 0
    end,
  },

  -- Format commands
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>fm", function() vim.lsp.buf.format() end, desc = "[F]ormat [m]arkup/code" },
      { "<leader>fm", function() vim.lsp.buf.format() end, mode = "v", desc = "[F]ormat region" },
    },
  },
  
  -- No Neck Pain - Center buffer for focused writing
  {
    "shortcuts/no-neck-pain.nvim",
    keys = {
      { "<leader>tn", "<cmd>NoNeckPain<cr>", desc = "[T]oggle [n]eck saver (center mode)" },
      { "<leader>tc", "<cmd>NoNeckPain<cr>", desc = "[T]oggle [c]enter mode" },
      { "<leader>t+", function() 
        require("no-neck-pain").resize(vim.api.nvim_win_get_width(0) + 5) 
      end, desc = "[T]oggle width [+] (increase)" },
      { "<leader>t-", function() 
        require("no-neck-pain").resize(vim.api.nvim_win_get_width(0) - 5) 
      end, desc = "[T]oggle width [-] (decrease)" },
    },
    config = function()
      require("no-neck-pain").setup({
        -- Width of the centered buffer
        width = 100,
        -- Buffer options
        buffers = {
          enabled = true,
          left = { enabled = true },
          right = { enabled = true },
          colors = {
            background = "#1a1b26", -- Dark background color
            blend = -0.2,
          },
          bo = {
            filetype = "no-neck-pain",
            buftype = "nofile",
            bufhidden = "hide",
            buflisted = false,
            swapfile = false,
          },
          wo = {
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = "0",
            number = false,
            relativenumber = false,
            foldenable = false,
            list = false,
            wrap = false,
            linebreak = false,
          },
        },
        -- Integration with other plugins
        integrations = {
          NeoTree = {
            position = "left",
            reopen = true,
          },
          NvimDAPUI = {
            position = "none",
            reopen = true,
          },
        },
      })
    end,
  },

  -- Save file keybind
  {
    "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>fs", "<cmd>w<cr>", desc = "[F]ile [s]ave" },
    },
  },
}