--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- NOTE: NIXCATS USERS:
-- NOTE: there are also notes added as a tutorial of how to use the nixCats lazy wrapper.
-- you can search for the following string in order to find them:
-- NOTE: nixCats:

-- like this one:
-- NOTE: nixCats: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}
require 'core.keymaps'
require 'core.options'

-- Set to true if you have a Nerd Font installed and selected in the terminal
-- NOTE: nixCats: we asked nix if we have it instead of setting it here.
-- because nix is more likely to know if we have a nerd font or not.
vim.g.have_nerd_font = nixCats 'have_nerd_font'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end
local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
-- NOTE: nixCats: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- Tree-sitter aware comments that keep the familiar "gc" mappings
  {
    'folke/ts-comments.nvim',
    opts = {
      ts_context_commentstring = {
        enable = true,
      },
    },
    config = function(_, opts)
      require('ts-comments').setup(opts)
    end,
  },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>b', group = '[B]uffer' },
        { '<leader>b_', hidden = true },
        { '<leader>c', group = '[C]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[D]ebug/Document' },
        { '<leader>d_', hidden = true },
        { '<leader>e', group = '[E]rror' },
        { '<leader>e_', hidden = true },
        { '<leader>f', group = '[F]ile' },
        { '<leader>f_', hidden = true },
        { '<leader>g', group = '[G]it' },
        { '<leader>g_', hidden = true },
        { '<leader>a', group = '[A]I' },
        { '<leader>a_', hidden = true },
        { '<leader>j', group = '[J]ump' },
        { '<leader>j_', hidden = true },
        { '<leader>l', group = '[L]SP' },
        { '<leader>l_', hidden = true },
        { '<leader>m', group = '[M]notes' },
        { '<leader>m_', hidden = true },
        { '<leader>o', group = '[O]pen' },
        { '<leader>o_', hidden = true },
        { '<leader>n', group = '[N]eominimap' },
        { '<leader>n_', hidden = true },
        { '<leader>p', group = '[P]roject' },
        { '<leader>p_', hidden = true },
        { '<leader>q', group = '[Q]uick/quit' },
        { '<leader>q_', hidden = true },
        { '<leader>r', group = '[R]ename' },
        { '<leader>r_', hidden = true },
        { '<leader>s', group = '[S]earch' },
        { '<leader>s_', hidden = true },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>t_', hidden = true },
        { '<leader>w', group = '[W]indow' },
        { '<leader>w_', hidden = true },
        {
          mode = { 'v' },
          { '<leader>h', group = 'Git [H]unk' },
          { '<leader>h_', hidden = true },
        },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      {
        'williamboman/mason.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
        config = true,
      }, -- NOTE: Must be loaded before dependants
      {
        'williamboman/mason-lspconfig.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
        -- because we will be using nix to download things instead.
        enabled = require('nixCatsUtils').lazyAdd(true, false),
      },

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- adds type hints for nixCats global
            { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
          },
        },
      },
      -- kickstart.nvim was still on neodev. lazydev is the new version of neodev
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', function() Snacks.picker.lsp_type_definitions() end, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>lr', vim.lsp.buf.rename, '[L]SP [r]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>la', vim.lsp.buf.code_action, '[L]SP code [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>ti', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle [I]nlay hints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      vim.lsp.config('*', { capabilities = capabilities })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      -- NOTE: nixCats: there is help in nixCats for lsps at `:h nixCats.LSPs` and also `:h nixCats.luaUtils`
      local util = require('lspconfig.util')
      local function rust_root_dir(fname)
        local rust_project = util.root_pattern('rust-project.json')(fname)
        if rust_project then
          return rust_project
        end

        local crate_dir = util.root_pattern('Cargo.toml')(fname)
        if not crate_dir then
          return util.root_pattern('.git')(fname)
        end

        local function has_workspace_manifest(dir)
          local manifest = util.path.join(dir, 'Cargo.toml')
          if not util.path.is_file(manifest) then
            return false
          end
          local ok, lines = pcall(vim.fn.readfile, manifest)
          if not ok then
            return false
          end
          for _, line in ipairs(lines) do
            if line:match('%s*%[workspace%]') then
              return true
            end
          end
          return false
        end

        if has_workspace_manifest(crate_dir) then
          return crate_dir
        end

        for parent in util.path.iterate_parents(crate_dir) do
          if has_workspace_manifest(parent) then
            return parent
          end
        end

        return crate_dir
      end
      local servers = {}

      -- Python LSP
      servers.pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = true },
              pyflakes = { enabled = true },
              autopep8 = { enabled = true },
              yapf = { enabled = false },
            },
          },
        },
      }

      -- Rust LSP
      servers.rust_analyzer = {
        -- Detect workspace roots without shelling out to `cargo metadata`.
        root_dir = rust_root_dir,
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      }

      -- C/C++ LSP
      servers.clangd = {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
      }

      -- Haskell LSP
      servers.hls = {
        filetypes = { 'haskell', 'lhaskell' },
        settings = {
          haskell = {
            formattingProvider = 'ormolu',
          },
        },
      }

      -- Gleam LSP
      servers.gleam = {}

      -- NOTE: nixCats: nixd is not available on mason.
      -- Feel free to check the nixd docs for more configuration options:
      -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
      if require('nixCatsUtils').isNixCats then
        servers.nixd = {}
      else
        servers.rnix = {}
        servers.nil_ls = {}
      end
      servers.lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = {
              globals = { 'nixCats' },
              disable = { 'missing-fields' },
            },
          },
        },
      }

      -- GitHub Copilot LSP (required for sidekick.nvim NES)
      servers.copilot = {}

      -- NOTE: nixCats: if nix, use lspconfig instead of mason
      -- You could MAKE it work, using lspsAndRuntimeDeps and sharedLibraries in nixCats
      -- but don't... its not worth it. Just add the lsp to lspsAndRuntimeDeps.
      if require('nixCatsUtils').isNixCats then
        -- set up the servers to be loaded on the appropriate filetypes!
        for server_name, cfg in pairs(servers) do
          vim.lsp.config(server_name, cfg)
          vim.lsp.enable(server_name)
        end
      else
        -- NOTE: nixCats: and if no nix, use mason

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              vim.lsp.config(server_name, servers[server_name] or {})
              vim.lsp.enable(server_name)
            end,
          },
        }
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        -- NOTE: nixCats: nix downloads it with a different file name.
        -- tell lazy about that.
        name = 'luasnip',
        build = require('nixCatsUtils').lazyAdd((function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)()),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<M-Down>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<M-Up>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept the completion with Enter; Tab is reserved for Copilot
          ['<CR>'] = cmp.mapping.confirm { select = true },
          --['<C-y>'] = cmp.mapping.confirm { select = true },
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:lua Snacks.picker.colorschemes()`.
    'navarasu/onedark.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Configure onedark.nvim with warmer style
      require('onedark').setup {
        style = 'warmer',
      }
      -- Load the colorscheme here. Some colorscheme plugins may offer multiple colorscheme choices or options.
      vim.cmd.colorscheme 'onedark'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      -- Use Treesitter-powered textobjects with sensible fallbacks
      local ai = require 'mini.ai'
      ai.setup {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
          t = ai.gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
        },
      }

      -- Gate autopairs behind the nixCats category so nix options still apply
      if require('nixCatsUtils').enableForCategory 'kickstart-autopairs' then
        local pairs = require 'mini.pairs'
        pairs.setup {
          modes = { insert = true, command = false, terminal = false },
          mappings = {
            ['"'] = { register = { cr = true } },
            ["'"] = { register = { cr = true } },
            ['`'] = { register = { cr = true } },
          },
        }

        -- Disable autopairs where it tends to get in the way (prompts, tree UIs)
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'snacks_picker_input', 'oil', 'neo-tree', 'spectre_panel', 'minifiles' },
          callback = function()
            vim.b.minipairs_disable = true
          end,
        })

        -- Add tex-friendly dollar pairing when editing TeX buffers
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'tex', 'latex', 'plaintex' },
          callback = function()
            require('mini.pairs').map_buf(0, 'i', '$', { action = 'closeopen', pair = '$$' })
          end,
        })
      end

      require('mini.operators').setup {
        replace = { prefix = 'gs' },
        -- Keep gx free for open-url mapping in core/keymaps.lua
        exchange = { prefix = 'gX' },
        multiply = { prefix = 'gm' },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    opts = {
      -- NOTE: nixCats: use lazyAdd to only set these 2 options if nix wasnt involved.
      -- because nix already ensured they were installed.
      ensure_installed = require('nixCatsUtils').lazyAdd { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      auto_install = require('nixCatsUtils').lazyAdd(true, false),
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      require('nvim-treesitter').setup(opts)

      -- Enable treesitter highlighting per buffer when filetype is detected
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- NOTE: nixCats: instead of uncommenting them, you can enable them
  -- from the categories set in your packageDefinitions in your flake or other template!
  -- This is because within them, we used nixCats to check if it should be loaded!
  -- NOTE: These plugins are now loaded automatically from lua/plugins/ subdirectories
  -- (ui/, navigation/, editing/, lsp/, git/, tools/, neorg/)

  -- Plugin specs organized by category under lua/plugins/
  -- Top-level: general.lua (mixed utilities)
  -- Subdirectories must be imported explicitly (lazy.nvim does not recurse)
  { import = 'plugins' },
  { import = 'plugins.ui' },
  { import = 'plugins.navigation' },
  { import = 'plugins.editing' },
  { import = 'plugins.lsp' },
  { import = 'plugins.git' },
  { import = 'plugins.tools' },
  { import = 'plugins.neorg' },
}, lazyOptions)

-- Configure nix-managed plugins that are not handled by lazy
-- Tiny Inline Diagnostics (managed by nix)
local ok, tiny_inline_diagnostic = pcall(require, 'tiny-inline-diagnostic')
if ok then
  tiny_inline_diagnostic.setup {
    -- Show diagnostic text inline
    signs = {
      left = '',
      right = '',
      diag = '●',
      arrow = '    ',
      up_arrow = '    ',
      vertical = ' │',
      vertical_end = ' └',
    },
    blend = {
      factor = 0.27,
    },
    options = {
      -- Show the source of the diagnostic
      show_source = false,
      -- Throttle the update of the diagnostic
      throttle = 20,
      -- Only show ERROR, WARN, INFO (excludes HINT/spelling)
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
      },
      softwrap = 15,
      -- Use multiline messages
      multilines = {
        enabled = true,
        always_show = true,
        trim_whitespaces = false,
        tabstop = 4,
      },
      -- Show all diagnostics on the line
      show_all_diags_on_cursorline = true,
      -- Enable diagnostic on insert mode
      enable_on_insert = true,
    },
  }
end

-- Precognition (managed by nix) - Show vim motions hints
local ok_precognition, precognition = pcall(require, 'precognition')
if ok_precognition then
  -- Pre-load submodules so deferred calls can find them
  -- after lazy.nvim has reconfigured the runtimepath
  pcall(require, 'precognition.utils')
  pcall(require, 'precognition.motions')
  precognition.setup {
    -- Keep hints hidden until explicitly toggled
    startVisible = false,
    showBlankVirtLine = true,
    -- Show hints for these motions
    hints = {
      Caret = { text = '^', prio = 2 },
      Dollar = { text = '$', prio = 0 }, -- Disabled by setting prio to 0
      MatchingParen = { text = '%', prio = 5 },
      Zero = { text = '0', prio = 0 }, -- Disabled by setting prio to 0
      w = { text = 'w', prio = 10 },
      b = { text = 'b', prio = 9 },
      e = { text = 'e', prio = 8 },
      W = { text = 'W', prio = 7 },
      B = { text = 'B', prio = 6 },
      E = { text = 'E', prio = 5 },
    },
    -- Highlight groups
    gutterHints = {
      G = { text = 'G', prio = 0 }, -- Disabled by setting prio to 0
      gg = { text = 'gg', prio = 0 }, -- Disabled by setting prio to 0
      PrevParagraph = { text = '{', prio = 8 },
      NextParagraph = { text = '}', prio = 8 },
    },
  }

  -- Ensure hints start hidden even if plugin defaults change
  precognition.hide()

  -- Add keybinding to toggle precognition
  vim.keymap.set('n', '<leader>tp', function()
    precognition.toggle()
  end, { desc = '[T]oggle [p]recognition hints' })
end

-- Hardtime (managed by nix) - Help break bad vim habits
local ok_hardtime, hardtime = pcall(require, 'hardtime')
if ok_hardtime then
  -- Pre-load submodules so the deferred 500ms timer can find them
  -- after lazy.nvim has reconfigured the runtimepath
  pcall(require, 'hardtime.command')
  pcall(require, 'hardtime.report')
  hardtime.setup {
    -- Enable by default
    enabled = true,
    -- Disable in certain filetypes
    disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil' },
    -- Maximum allowed repetitions
    max_count = 3,
    -- Time restriction in milliseconds
    restriction_mode = 'block',
    -- Allow mouse actions
    allow_different_key = true,
    disabled_keys = {
      ['<Up>'] = {},
      ['<Down>'] = {},
      ['<Left>'] = {},
      ['<Right>'] = {},
      ['<ScrollWheelUp>'] = {},
      ['<ScrollWheelDown>'] = {},
      ['<C-ScrollWheelUp>'] = {},
      ['<C-ScrollWheelDown>'] = {},
      ['<S-ScrollWheelUp>'] = {},
      ['<S-ScrollWheelDown>'] = {},
    },
    -- Restricted keys
    restricted_keys = {
      ['h'] = { 'n', 'x' },
      ['j'] = { 'n', 'x' },
      ['k'] = { 'n', 'x' },
      ['l'] = { 'n', 'x' },
      ['-'] = { 'n', 'x' },
      ['+'] = { 'n', 'x' },
      ['gj'] = { 'n', 'x' },
      ['gk'] = { 'n', 'x' },
      ['<CR>'] = { 'n', 'x' },
      ['<C-M>'] = { 'n', 'x' },
      ['<C-N>'] = { 'n', 'x' },
      ['<C-P>'] = { 'n', 'x' },
    },
    -- Hints for better alternatives
    hints = {
      ['k^'] = {
        message = function()
          return 'Use - instead of k^'
        end,
        length = 2,
      },
    },
  }

  -- Add keybinding to toggle hardtime
  vim.keymap.set('n', '<leader>th', function()
    hardtime.toggle()
  end, { desc = '[T]oggle [h]ardtime' })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
