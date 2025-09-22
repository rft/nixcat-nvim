return {
  'nvim-neorg/neorg',
  lazy = false,
  version = '*',
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            -- Make Neorg look better with concealing
            icon_preset = 'varied',
            icons = {
              todo = {
                undone = '󰄱',
                pending = '󰥔',
                done = '󰄲',
                cancelled = '󰅖',
                recurring = '󰑖',
                uncertain = '󰇽',
                urgent = '󰀦',
                on_hold = '󰻃',
              },
              heading = {
                icons = { '󰲡', '󰲣', '󰲥', '󰲧', '󰲩', '󰲫' },
              },
            },
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
              work = '~/work-notes',
              personal = '~/personal-notes',
            },
            default_workspace = 'notes',
          },
        },
        ['core.completion'] = {
          config = {
            engine = 'nvim-cmp',
          },
        },
        ['core.integrations.nvim-cmp'] = {},
        ['core.export'] = {},
        ['core.export.markdown'] = {},
        ['core.keybinds'] = {
          config = {
            default_keybinds = false, -- Disable defaults to create Doom-style mappings
            neorg_leader = '<LocalLeader>',
          },
        },
      },
    }

    -- Doom Emacs-style keybinds for Neorg
    vim.api.nvim_create_autocmd('Filetype', {
      pattern = 'norg',
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Note management (Doom's SPC n prefix style)
        vim.keymap.set('n', '<leader>nn', '<cmd>Neorg workspace notes<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [N]otes workspace' }))
        vim.keymap.set('n', '<leader>nw', '<cmd>Neorg workspace work<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [W]ork workspace' }))
        vim.keymap.set('n', '<leader>np', '<cmd>Neorg workspace personal<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [P]ersonal workspace' }))
        vim.keymap.set('n', '<leader>ni', '<cmd>Neorg index<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [I]ndex' }))
        vim.keymap.set('n', '<leader>nr', '<cmd>Neorg return<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [R]eturn' }))
        vim.keymap.set('n', '<leader>nt', '<cmd>Neorg toc<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [T]able of contents' }))

        -- Mode-specific keybinds (Doom's SPC m prefix style)
        vim.keymap.set('n', '<leader>mn', '<Plug>(neorg.dirman.new-note)', vim.tbl_extend('force', opts, { desc = '[M]ode [N]ew note' }))
        vim.keymap.set('n', '<leader>mt', '<Plug>(neorg.qol.todo-items.todo.task-cycle)', vim.tbl_extend('force', opts, { desc = '[M]ode [T]ask cycle' }))
        vim.keymap.set('n', '<leader>md', '<Plug>(neorg.tempus.insert-date)', vim.tbl_extend('force', opts, { desc = '[M]ode Insert [D]ate' }))

        -- Task management (org-mode style)
        vim.keymap.set('n', '<C-c><C-t>', '<Plug>(neorg.qol.todo-items.todo.task-cycle)', vim.tbl_extend('force', opts, { desc = 'Cycle task state' }))
        vim.keymap.set('n', '<leader>tc', '<Plug>(neorg.qol.todo-items.todo.task-cycle)', vim.tbl_extend('force', opts, { desc = '[T]ask [C]ycle' }))
        vim.keymap.set('n', '<leader>tu', '<Plug>(neorg.qol.todo-items.todo.task-undone)', vim.tbl_extend('force', opts, { desc = '[T]ask [U]ndone' }))
        vim.keymap.set('n', '<leader>tp', '<Plug>(neorg.qol.todo-items.todo.task-pending)', vim.tbl_extend('force', opts, { desc = '[T]ask [P]ending' }))
        vim.keymap.set('n', '<leader>td', '<Plug>(neorg.qol.todo-items.todo.task-done)', vim.tbl_extend('force', opts, { desc = '[T]ask [D]one' }))
        vim.keymap.set('n', '<leader>tC', '<Plug>(neorg.qol.todo-items.todo.task-cancelled)', vim.tbl_extend('force', opts, { desc = '[T]ask [C]ancelled' }))
        vim.keymap.set('n', '<leader>tr', '<Plug>(neorg.qol.todo-items.todo.task-recurring)', vim.tbl_extend('force', opts, { desc = '[T]ask [R]ecurring' }))
        vim.keymap.set('n', '<leader>th', '<Plug>(neorg.qol.todo-items.todo.task-on-hold)', vim.tbl_extend('force', opts, { desc = '[T]ask on [H]old' }))

        -- List management
        vim.keymap.set('n', '<leader>lt', '<Plug>(neorg.pivot.list.toggle)', vim.tbl_extend('force', opts, { desc = '[L]ist [T]oggle' }))
        vim.keymap.set('n', '<leader>li', '<Plug>(neorg.pivot.list.invert)', vim.tbl_extend('force', opts, { desc = '[L]ist [I]nvert' }))

        -- Promotion and demotion (org-mode style)
        vim.keymap.set('n', 'M-<Right>', '<Plug>(neorg.promo.promote)', vim.tbl_extend('force', opts, { desc = 'Promote heading' }))
        vim.keymap.set('n', 'M-<Left>', '<Plug>(neorg.promo.demote)', vim.tbl_extend('force', opts, { desc = 'Demote heading' }))
        vim.keymap.set('n', 'M-<Up>', '<Plug>(neorg.promo.promote.nested)', vim.tbl_extend('force', opts, { desc = 'Promote heading (nested)' }))
        vim.keymap.set('n', 'M-<Down>', '<Plug>(neorg.promo.demote.nested)', vim.tbl_extend('force', opts, { desc = 'Demote heading (nested)' }))

        -- Alternative promotion/demotion (vim-style)
        vim.keymap.set('n', '>>', '<Plug>(neorg.promo.promote)', vim.tbl_extend('force', opts, { desc = 'Promote heading' }))
        vim.keymap.set('n', '<<', '<Plug>(neorg.promo.demote)', vim.tbl_extend('force', opts, { desc = 'Demote heading' }))

        -- Navigation and links
        vim.keymap.set('n', '<CR>', '<Plug>(neorg.esupports.hop.hop-link)', vim.tbl_extend('force', opts, { desc = 'Follow link' }))
        vim.keymap.set('n', 'gf', '<Plug>(neorg.esupports.hop.hop-link)', vim.tbl_extend('force', opts, { desc = 'Follow link' }))
        vim.keymap.set('n', '<C-]>', '<Plug>(neorg.esupports.hop.hop-link)', vim.tbl_extend('force', opts, { desc = 'Follow link' }))
        vim.keymap.set('n', '<Tab>', '<Plug>(neorg.qol.todo-items.todo.task-cycle)', vim.tbl_extend('force', opts, { desc = 'Cycle task or follow link' }))

        -- Insert mode mappings
        vim.keymap.set('i', '<C-t>', '<Plug>(neorg.promo.promote)', vim.tbl_extend('force', opts, { desc = 'Promote heading (insert)' }))
        vim.keymap.set('i', '<C-d>', '<Plug>(neorg.promo.demote)', vim.tbl_extend('force', opts, { desc = 'Demote heading (insert)' }))

        -- Code blocks (like org-mode)
        vim.keymap.set('n', '<leader>cm', '<Plug>(neorg.looking-glass.magnify-code-block)', vim.tbl_extend('force', opts, { desc = '[C]ode [M]agnify block' }))
        vim.keymap.set('n', '<C-c><C-c>', '<Plug>(neorg.looking-glass.magnify-code-block)', vim.tbl_extend('force', opts, { desc = 'Magnify code block' }))

        -- Export (org-mode style)
        vim.keymap.set('n', '<leader>me', '<cmd>Neorg export to-file<CR>', vim.tbl_extend('force', opts, { desc = '[M]ode [E]xport' }))

        -- Folding (org-mode style)
        vim.keymap.set('n', '<S-Tab>', 'za', vim.tbl_extend('force', opts, { desc = 'Toggle fold' }))
        vim.keymap.set('n', 'zm', 'zM', vim.tbl_extend('force', opts, { desc = 'Close all folds' }))
        vim.keymap.set('n', 'zr', 'zR', vim.tbl_extend('force', opts, { desc = 'Open all folds' }))

        -- Journal/diary commands (moved to <leader>nj to avoid conflict with jump)
        vim.keymap.set('n', '<leader>njt', '<cmd>Neorg journal today<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [J]ournal [T]oday' }))
        vim.keymap.set('n', '<leader>njy', '<cmd>Neorg journal yesterday<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [J]ournal [Y]esterday' }))
        vim.keymap.set('n', '<leader>njm', '<cmd>Neorg journal tomorrow<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [J]ournal to[M]orrow' }))
        vim.keymap.set('n', '<leader>njc', '<cmd>Neorg journal custom<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [J]ournal [C]ustom date' }))

        -- Telescope integration (if available)
        local has_telescope, _ = pcall(require, 'telescope')
        if has_telescope then
          vim.keymap.set('n', '<leader>nf', '<cmd>Telescope neorg find_norg_files<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [F]ind files' }))
          vim.keymap.set('n', '<leader>nh', '<cmd>Telescope neorg search_headings<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [H]eadings' }))
          vim.keymap.set('n', '<leader>nl', '<cmd>Telescope neorg find_linkable<CR>', vim.tbl_extend('force', opts, { desc = '[N]eorg [L]inkable' }))
        end
      end,
    })

    -- Add neorg group to which-key if available
    local has_which_key, which_key = pcall(require, 'which-key')
    if has_which_key then
      which_key.add {
        { '<leader>n', group = '[N]eorg', mode = { 'n', 'v' } },
        { '<leader>nj', group = '[N]eorg [J]ournal', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]ask', mode = { 'n', 'v' } },
        { '<leader>l', group = '[L]ist', mode = { 'n', 'v' } },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'v' } },
        { '<leader>m', group = '[M]ode specific', mode = { 'n', 'v' } },
      }
    end
  end,
}