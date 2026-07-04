-- Rename the symbol under the cursor via a small floating prompt window.
local function floating_rename()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local supports = false
  for _, client in ipairs(clients) do
    if client:supports_method 'textDocument/rename' then
      supports = true
      break
    end
  end

  if not supports then
    vim.notify('No attached LSP server supports rename', vim.log.levels.WARN)
    return
  end

  local current_name = vim.fn.expand '<cword>'
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'prompt'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'lsp_rename_prompt'

  local float_opts = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = math.max(30, #current_name + 12),
    height = 1,
    style = 'minimal',
    border = 'rounded',
    title = ' Rename Symbol ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, float_opts)
  vim.fn.prompt_setprompt(buf, 'New name: ')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { current_name })
  vim.api.nvim_win_set_cursor(win, { 1, #current_name })

  local function close_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.fn.prompt_setcallback(buf, function(new_name)
    new_name = vim.trim(new_name or '')
    close_window()
    if new_name == '' or new_name == current_name then
      return
    end
    vim.schedule(function()
      vim.lsp.buf.rename(new_name)
    end)
  end)

  vim.fn.prompt_setinterrupt(buf, function()
    close_window()
  end)

  vim.keymap.set('n', '<Esc>', close_window, { buffer = buf, nowait = true })
  vim.keymap.set('i', '<Esc>', close_window, { buffer = buf, nowait = true })

  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = buf,
    once = true,
    callback = close_window,
  })

  vim.cmd 'startinsert!'
end

-- Detect Rust workspace roots without shelling out to `cargo metadata`.
-- Uses the vim.lsp.config root_dir signature: (bufnr, on_dir).
local function rust_root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  local rust_project = vim.fs.root(fname, 'rust-project.json')
  if rust_project then
    return on_dir(rust_project)
  end

  local crate_dir = vim.fs.root(fname, 'Cargo.toml')
  if not crate_dir then
    local git_dir = vim.fs.root(fname, '.git')
    if git_dir then
      on_dir(git_dir)
    end
    return
  end

  local function has_workspace_manifest(dir)
    local manifest = dir .. '/Cargo.toml'
    local ok, lines = pcall(vim.fn.readfile, manifest)
    if not ok then
      return false
    end
    for _, line in ipairs(lines) do
      if line:match '%s*%[workspace%]' then
        return true
      end
    end
    return false
  end

  if has_workspace_manifest(crate_dir) then
    return on_dir(crate_dir)
  end

  for parent in vim.fs.parents(crate_dir) do
    if has_workspace_manifest(parent) then
      return on_dir(parent)
    end
  end

  on_dir(crate_dir)
end

return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
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
        enabled = require('nixCatsUtils').lazyAdd(true, false),
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        enabled = require('nixCatsUtils').lazyAdd(true, false),
      },

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
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
    },
    config = function()
      -- This function gets run when an LSP attaches to a particular buffer:
      -- every time a new file associated with an lsp is opened, this
      -- configures the current buffer. All LSP keymaps live here so they are
      -- buffer-local and only active when a server is actually attached.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-t>.
          local goto_definition = function()
            Snacks.picker.lsp_definitions()
          end
          -- Find references for the word under your cursor.
          local goto_references = function()
            Snacks.picker.lsp_references()
          end
          -- Jump to the type of the word under your cursor.
          local goto_type_definition = function()
            Snacks.picker.lsp_type_definitions()
          end

          map('gd', goto_definition, '[G]oto [D]efinition')
          map('gr', goto_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', function()
            Snacks.picker.lsp_implementations()
          end, '[G]oto [I]mplementation')

          map('<leader>D', goto_type_definition, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          map('<leader>ds', function()
            Snacks.picker.lsp_symbols()
          end, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          map('<leader>ws', function()
            Snacks.picker.lsp_workspace_symbols()
          end, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          map('<leader>lr', vim.lsp.buf.rename, '[L]SP [r]ename')

          -- Execute a code action; usually your cursor needs to be on top of
          -- an error or a suggestion from your LSP for this to activate.
          map('<leader>la', vim.lsp.buf.code_action, '[L]SP code [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- <leader>c aliases for the same operations
          map('<leader>cd', goto_definition, 'Jump to definition')
          map('<leader>cr', goto_references, 'Find references')
          map('<leader>ck', vim.lsp.buf.hover, 'Jump to documentation')
          map('<leader>ct', goto_type_definition, 'Find type definition')
          map('<leader>cR', floating_rename, 'Rename symbol')
          map('<leader>co', function()
            vim.lsp.buf.code_action {
              filter = function(action)
                return action.kind and action.kind:match 'source.organizeImports'
              end,
              apply = true,
            }
          end, 'Organize imports')

          -- Highlight references of the word under your cursor when your
          -- cursor rests there for a little while; clear on move.
          --    See `:help CursorHold` for information about when this is executed
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Ruff and ty both attach to Python buffers. Let ty own hover so we
          -- don't get an empty/duplicate popup from Ruff on `K`.
          if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end

          if client and client:supports_method 'textDocument/documentHighlight' then
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

          -- Toggle inlay hints, if the language server supports them.
          -- This may be unwanted, since they displace some of your code.
          if client and client:supports_method 'textDocument/inlayHint' and vim.lsp.inlay_hint then
            map('<leader>ti', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle [I]nlay hints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  With nvim-cmp, Neovim has *more* capabilities, so we broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      vim.lsp.config('*', { capabilities = capabilities })

      -- Enable the following language servers
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      -- NOTE: nixCats: there is help in nixCats for lsps at `:h nixCats.LSPs` and also `:h nixCats.luaUtils`
      local servers = {}

      -- Python LSPs (Astral): `ruff` handles linting + formatting, `ty`
      -- handles type checking and IDE features (hover, go-to-definition, etc.).
      -- Both ship as `ruff server` / `ty server` and are installed via nix.
      servers.ruff = {}
      servers.ty = {}

      -- Rust LSP
      servers.rust_analyzer = {
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

      -- NOTE: nixCats: if nix, use lspconfig instead of mason.
      -- Just add the lsp to lspsAndRuntimeDeps in the flake.
      if require('nixCatsUtils').isNixCats then
        for server_name, cfg in pairs(servers) do
          vim.lsp.config(server_name, cfg)
          vim.lsp.enable(server_name)
        end
      else
        -- NOTE: nixCats: and if no nix, use mason
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
}
