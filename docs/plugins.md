# Plugin Reference

This document lists every plugin used in the nixcat-nvim configuration, grouped by category. Each entry includes the plugin name, purpose, notable configuration, key keybinds, and the source file where it is configured.

## Table of Contents

- [Core / Framework](#core--framework)
- [Colorscheme](#colorscheme)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [Completion](#completion)
- [Treesitter](#treesitter)
- [Search and Navigation](#search-and-navigation)
- [File Management](#file-management)
- [Buffer Management](#buffer-management)
- [Git](#git)
- [Debugging (DAP)](#debugging-dap)
- [Error Management](#error-management)
- [AI / Assistants](#ai--assistants)
- [Editing and Text Manipulation](#editing-and-text-manipulation)
- [Comments](#comments)
- [UI Enhancements](#ui-enhancements)
- [Code Minimap](#code-minimap)
- [Indent Guides](#indent-guides)
- [Diagnostics Display](#diagnostics-display)
- [Linting and Formatting](#linting-and-formatting)
- [Sessions and Persistence](#sessions-and-persistence)
- [Notes / Writing](#notes--writing)
- [Database](#database)
- [Terminal and Scratch](#terminal-and-scratch)
- [REPL Integration](#repl-integration)
- [Quality of Life](#quality-of-life)

---

## Core / Framework

### lazy.nvim
- **Purpose**: Plugin manager. Handles lazy-loading, dependencies, and plugin lifecycle.
- **Config**: `init.lua:166`
- **Notes**: Wrapped via `nixCatsUtils.lazyCat` to support both Nix and non-Nix installations.

### which-key.nvim
- **Plugin**: `folke/which-key.nvim`
- **Purpose**: Shows pending keybinds in a popup when a prefix key is pressed.
- **Config**: `init.lua:226`
- **Notes**: Defines all `<leader>` prefix group labels (Buffer, Code, Debug, Error, File, Git, AI, Jump, LSP, etc.).

### snacks.nvim
- **Plugin**: `folke/snacks.nvim`
- **Purpose**: Collection of small utilities - fuzzy picker (files, grep, LSP, buffers, etc.), terminal, dashboard, buffer delete, git browse, scratch pads, notifications, smooth scroll, word highlighting, scope/indent, big file handling, and `vim.ui.select` replacement.
- **Config**: `lua/plugins/tools/snacks.lua`
- **Key features**: Fuzzy picker (replaces Telescope), floating/split terminal, dashboard on startup, buffer delete, scratch buffers, notification history, git browse/blame, smooth scrolling, scope textobjects.
- **Keybinds**: `<leader>sh` (help), `<leader>sk` (keymaps), `<leader>sf` (files), `<leader>sg` (grep), `<leader>sd` (diagnostics), `<leader>sr` (resume), `<leader>s.` (recent), `<leader>st` (all pickers), `<leader><leader>` (command palette), `<leader>/` (buffer search), `<leader>ff` (smart find), `<leader>pp` (projects), `<leader>bb` (buffers), `<leader>ot` (terminal), `<leader>os` (split terminal), `<leader>gB` (git browse), `<leader>gl` (git blame line), `<leader>ps` (scratch), `<leader>pS` (pick scratch), `<leader>bd`/`bD` (delete buffer), `<leader>pn` (notifications), `<leader>pd` (dashboard).

### plenary.nvim
- **Plugin**: `nvim-lua/plenary.nvim`
- **Purpose**: Lua utility library used as a dependency by many plugins.

### nvim-web-devicons
- **Plugin**: `nvim-tree/nvim-web-devicons`
- **Purpose**: File type icons (requires Nerd Font). Used by many UI plugins.
- **Config**: `init.lua` (enabled based on `have_nerd_font`).

---

## Colorscheme

### onedark.nvim
- **Plugin**: `navarasu/onedark.nvim`
- **Purpose**: One Dark colorscheme with the "warmer" style variant.
- **Config**: `init.lua:975`
- **Notes**: Loaded with high priority (1000) to ensure it applies before other plugins.

---

## LSP (Language Server Protocol)

### nvim-lspconfig
- **Plugin**: `neovim/nvim-lspconfig`
- **Purpose**: Configuration for built-in Neovim LSP client.
- **Config**: `init.lua:479`
- **Configured servers**: `lua_ls`, `pylsp`, `rust_analyzer`, `clangd`, `hls`, `gleam`, `nixd` (Nix) or `rnix`/`nil_ls` (non-Nix), `copilot`.
- **LSP keybinds** (buffer-local on attach): `gd` (definition), `gr` (references), `gI` (implementation), `gD` (declaration), `K` (hover), `<leader>D` (type definition), `<leader>ds` (document symbols), `<leader>ws` (workspace symbols), `<leader>lr` (rename), `<leader>la` (code action), `<leader>ti` (toggle inlay hints).
- **Code action keybinds** (`lua/plugins/lsp/lsp.lua`): `<leader>;` (toggle comment), `<leader>cc` (make), `<leader>cd` (definition), `<leader>cr` (references), `<leader>ck` (hover), `<leader>cR` (floating rename), `<leader>cx` (diagnostics float), `<leader>ct` (type definition), `<leader>co` (organize imports), `<leader>cw` (remove trailing whitespace), `<leader>cW` (remove trailing newlines), `<leader>ce`/`cE` (next/prev diagnostic), `]e`/`[e` (next/prev error), `]w`/`[w` (next/prev warning), `]h`/`[h` (next/prev hint).

### mason.nvim / mason-lspconfig.nvim / mason-tool-installer.nvim
- **Plugins**: `williamboman/mason.nvim`, `williamboman/mason-lspconfig.nvim`, `WhoIsSethDaniel/mason-tool-installer.nvim`
- **Purpose**: Automatic LSP server installation (only enabled when NOT using Nix).
- **Config**: `init.lua:484-498`

### fidget.nvim
- **Plugin**: `j-hui/fidget.nvim`
- **Purpose**: Shows LSP progress notifications in the bottom-right corner.
- **Config**: `init.lua:505`

### lazydev.nvim
- **Plugin**: `folke/lazydev.nvim`
- **Purpose**: Configures Lua LSP for Neovim config development (completion, annotations, signatures).
- **Config**: `init.lua:510`
- **Notes**: Adds type hints for the `nixCats` global.

---

## Completion

### nvim-cmp
- **Plugin**: `hrsh7th/nvim-cmp`
- **Purpose**: Autocompletion engine.
- **Config**: `init.lua:862`
- **Sources**: `nvim_lsp`, `luasnip`, `path`.
- **Keybinds** (insert mode): `<M-Down>`/`<M-Up>` (next/prev item), `<C-b>`/`<C-f>` (scroll docs), `<CR>` (confirm), `<C-Space>` (trigger completion), `<C-l>`/`<C-h>` (snippet jump forward/backward).

### LuaSnip
- **Plugin**: `L3MON4D3/LuaSnip`
- **Purpose**: Snippet engine used by nvim-cmp.
- **Config**: `init.lua:871`

### cmp-nvim-lsp / cmp-path / cmp_luasnip
- **Purpose**: Completion sources for LSP, file paths, and snippets.

---

## Treesitter

### nvim-treesitter
- **Plugin**: `nvim-treesitter/nvim-treesitter`
- **Purpose**: Syntax highlighting, indentation, and code understanding via tree-sitter parsers.
- **Config**: `init.lua:1070`
- **Notes**: Parsers are managed by Nix when using nixCats, otherwise auto-installed.

### nvim-treesitter-textobjects
- **Plugin**: `nvim-treesitter/nvim-treesitter-textobjects`
- **Purpose**: Treesitter-powered text objects used by mini.ai.
- **Config**: Loaded as dependency of `mini.nvim`.

### nvim-treesitter-context
- **Plugin**: `nvim-treesitter/nvim-treesitter-context`
- **Purpose**: Shows the current function/class context at the top of the buffer as you scroll.
- **Config**: `lua/plugins/ui/treesitter-context.lua`
- **Keybinds**: `<leader>tc` (toggle context).
- **Category**: Requires `general`.

### nvim-ts-context-commentstring
- **Plugin**: `JoosepAlviste/nvim-ts-context-commentstring`
- **Purpose**: Sets the correct comment string based on treesitter context (useful for embedded languages like JSX).
- **Config**: `lua/plugins/editing/comments.lua`

### ts-comments.nvim
- **Plugin**: `folke/ts-comments.nvim`
- **Purpose**: Tree-sitter aware commenting with the familiar `gc` mappings.
- **Config**: `init.lua:181`

---

## Search and Navigation

### Snacks picker (part of snacks.nvim)
- **Purpose**: Fuzzy finder for files, LSP symbols, help, keymaps, buffers, diagnostics, and more. Also provides `vim.ui.select` replacement.
- **Config**: `lua/plugins/tools/snacks.lua`
- **Keybinds**: `<leader>sh` (help), `<leader>sk` (keymaps), `<leader>sf` (files), `<leader>ss` (current buffer), `<leader>sw` (grep word), `<leader>sg` (grep), `<leader>sd` (diagnostics), `<leader>sr` (resume), `<leader>s.` (recent files), `<leader>st` (all pickers), `<leader><leader>` (command palette), `<leader>/` (fuzzy find in buffer), `<leader>s/` (grep open files), `<leader>sn` (neovim config files), `<leader>sp` (project grep with hidden), `<leader>sP` (standard project grep), `<leader>pp` (projects), `<leader>ff` (smart find), `<leader>of` (open file), `<leader>fF` (find files), `<C-S-f>` (grep).

### flash.nvim
- **Plugin**: `folke/flash.nvim`
- **Purpose**: Fast jump/motion plugin with labels. Supports word jump, treesitter node jump, remote flash, and treesitter search.
- **Config**: `lua/plugins/navigation/jump.lua`
- **Keybinds**: `<leader>jw` (jump to word), `<leader>jt` (treesitter node), `<leader>jf` (jump to window), `<leader>jtf` (treesitter function/method), `<leader>jtc` (treesitter class/struct), `<leader>jtb` (treesitter loop/conditional), `<leader>jr` (remote flash, operator mode), `<leader>jR` (treesitter search), `<leader>jl` (jump to line).
- **Notes**: Flash char mode is disabled during vim-visual-multi sessions.

### eyeliner.nvim
- **Plugin**: `jinh0/eyeliner.nvim`
- **Purpose**: Enhanced `f`/`F`/`t`/`T` movement with unique character indicators highlighted on keypress.
- **Config**: `lua/plugins/navigation/jump.lua`
- **Notes**: Disabled during vim-visual-multi sessions.

### nvim-hlslens
- **Plugin**: `kevinhwang91/nvim-hlslens`
- **Purpose**: Search match lens overlay - shows current match index via statusline integration.
- **Config**: `lua/plugins/navigation/search.lua`
- **Keybinds**: Enhanced `n`, `N`, `*`, `#`, `g*`, `g#` with lens activation.

### grug-far.nvim
- **Plugin**: `MagicDuck/grug-far.nvim`
- **Purpose**: Project-wide search and replace UI.
- **Config**: `lua/plugins/navigation/search.lua`
- **Keybinds**: `<leader>sR` (replace UI), `<leader>sW` (replace with cursor word), `<leader>sR` (visual: replace with selection).

### vim-illuminate
- **Plugin**: `RRethy/vim-illuminate`
- **Purpose**: Highlights other uses of the word under cursor using LSP, treesitter, or regex.
- **Config**: `lua/plugins/ui/illuminate.lua`
- **Keybinds**: `]r` (next reference), `[r` (previous reference).
- **Category**: Requires `general`.

---

## File Management

### neo-tree.nvim
- **Plugin**: `nvim-neo-tree/neo-tree.nvim`
- **Purpose**: File tree explorer sidebar with git status and diagnostics.
- **Config**: `lua/plugins/navigation/neo-tree.lua`
- **Keybinds**: `\` (reveal), `<leader>ft` (toggle).
- **Category**: Requires `kickstart-neo-tree`.
- **Notes**: Integrates with `snacks.rename` for file move/rename notifications.

### oil.nvim
- **Plugin**: `stevearc/oil.nvim`
- **Purpose**: File browser that lets you edit the filesystem like a buffer.
- **Config**: `lua/plugins/general.lua`
- **Keybinds**: `<leader>fo` (toggle Oil).
- **Oil buffer keys**: `g?` (help), `<CR>` (open), `<C-s>` (vsplit), `<C-h>` (split), `<C-t>` (tab), `<C-p>` (preview), `<C-c>` (close), `<C-l>` (refresh), `-` (parent), `_` (open cwd), `` ` `` (cd), `~` (tcd), `gs` (change sort), `gx` (open external), `g.` (toggle hidden), `g\` (toggle trash).

### undotree
- **Plugin**: `mbbill/undotree`
- **Purpose**: Visualize and navigate the undo history tree.
- **Config**: `lua/plugins/general.lua`
- **Keybinds**: `<leader>ou` (toggle undo tree).

### arrow.nvim
- **Plugin**: `otavioschwanck/arrow.nvim`
- **Purpose**: Quick file bookmark navigator for workspace-level marks.
- **Config**: `lua/plugins/navigation/arrow.lua`
- **Keybinds**: `<leader>wt` (toggle mark), `<leader>wn` (next mark), `<leader>wp` (previous mark), `<leader>wm` (open menu), `<leader>w1`..`<leader>w9` (jump to mark 1-9).
- **Category**: Requires `general`.

---

## Buffer Management

### bufferline.nvim
- **Plugin**: `akinsho/bufferline.nvim`
- **Purpose**: Buffer tab bar with diagnostics indicators, pin support, and hover previews.
- **Config**: `lua/plugins/ui/buffers.lua`
- **Keybinds**: `[b` (prev buffer), `]b` (next buffer), `<leader>bp` (toggle pin), `<leader>bP` (close unpinned), `<leader>bn` (new buffer).

### Buffer operations (via Snacks and plenary)
- **Config**: `lua/plugins/tools/snacks.lua`, `lua/plugins/ui/buffers.lua`
- **Keybinds**: `<leader>bb`/`<leader>,` (buffer picker workspace), `<leader>bB`/`<leader><S-,>` (buffer picker all), `<leader>bc` (close buffer), `<leader>bs` (scratch buffer), `<leader>bu` (reopen last), `<leader>bl`/`bh`/`bj`/`bk` (move buffer to adjacent window).

---

## Git

### neogit
- **Plugin**: `NeogitOrg/neogit`
- **Purpose**: Magit-like git interface for Neovim.
- **Config**: `lua/plugins/git/git.lua`
- **Keybinds**: `<leader>gg` (open Neogit).
- **Notes**: Integrates with diffview.

### diffview.nvim
- **Plugin**: `sindrets/diffview.nvim`
- **Purpose**: Side-by-side diff viewer and file history browser.
- **Config**: `lua/plugins/git/git.lua`
- **Keybinds**: `<leader>gdo` (open), `<leader>gdc` (close), `<leader>gdf` (file history), `<leader>gdt` (toggle files panel).

### gitsigns.nvim
- **Plugin**: `lewis6991/gitsigns.nvim`
- **Purpose**: Git change signs in the gutter, hunk operations, blame, and diff.
- **Config**: `init.lua:197` (signs config) and `lua/plugins/git/git.lua` (keybinds).
- **Keybinds**: `]c`/`[c` (next/prev hunk), `<leader>gs` (stage hunk), `<leader>gr` (reset hunk), `<leader>gS` (stage buffer), `<leader>gu` (undo stage), `<leader>gR` (reset buffer), `<leader>gp` (preview hunk), `<leader>gb` (blame line), `<leader>gd` (diff index), `<leader>gD` (diff last commit), `<leader>gtb` (toggle line blame), `<leader>gtd` (toggle deleted).
- **Category**: Requires `kickstart-gitsigns`.

---

## Debugging (DAP)

### nvim-dap
- **Plugin**: `mfussenegger/nvim-dap`
- **Purpose**: Debug Adapter Protocol client for Neovim.
- **Config**: `lua/plugins/tools/debug.lua`
- **Keybinds**: `<F5>` (start/continue), `<F1>` (step into), `<F2>` (step over), `<F3>` (step out), `<F7>` (toggle UI), `<leader>db` (toggle breakpoint), `<leader>dB` (conditional breakpoint), `<leader>dl` (run last), `<leader>dr` (toggle REPL), `<leader>dc` (continue), `<leader>de` (evaluate), `<leader>dx` (terminate + close UI), `<leader>du` (toggle UI). In DAP buffers: `q` (close).
- **Category**: Requires `kickstart-debug`.

### nvim-dap-ui
- **Plugin**: `rcarriga/nvim-dap-ui`
- **Purpose**: UI for nvim-dap (scopes, breakpoints, stacks, watches, REPL, console).
- **Config**: `lua/plugins/tools/debug.lua`

### nvim-dap-go
- **Plugin**: `leoluz/nvim-dap-go`
- **Purpose**: Go debugging configuration for DAP using Delve.

---

## Error Management

### trouble.nvim
- **Plugin**: `folke/trouble.nvim`
- **Purpose**: Pretty diagnostics list with filtering and navigation.
- **Config**: `lua/plugins/tools/errors.lua`
- **Keybinds**: `<leader>ee` (toggle diagnostics), `<leader>ef` (code action fix), `<leader>el` (buffer diagnostics), `<leader>en` (next error), `<leader>eN`/`<leader>ep` (previous error).

---

## AI / Assistants

### copilot.vim
- **Plugin**: `github/copilot.vim`
- **Purpose**: GitHub Copilot inline code suggestions.
- **Config**: `lua/plugins/tools/copilot.lua`
- **Keybinds**: `<Tab>` (accept suggestion, prioritizes Sidekick NES first), `<leader>cT` (toggle Copilot per buffer).
- **Notes**: Custom Nix-packaged. Default tab map disabled; custom handler prioritizes Sidekick NES before Copilot suggestions.

### sidekick.nvim
- **Plugin**: `folke/sidekick.nvim`
- **Purpose**: AI coding assistant with CLI interface and next-edit suggestions (NES).
- **Config**: `lua/plugins/tools/sidekick.lua`
- **Keybinds**: `<leader>an` (apply next edit), `<leader>aN` (toggle NES), `<leader>aa` (toggle CLI), `<leader>ap` (prompt CLI), `<leader>as` (send selection to CLI, visual), `<leader>af` (focus CLI window).
- **Notes**: Custom Nix-packaged. Requires Copilot LSP.

---

## Editing and Text Manipulation

### mini.nvim
- **Plugin**: `echasnovski/mini.nvim`
- **Purpose**: Collection of small independent modules.
- **Config**: `init.lua:993`
- **Modules used**:
  - **mini.ai**: Enhanced text objects with treesitter support (`af`/`if` for functions, `ac`/`ic` for classes, `ao`/`io` for blocks/loops, `at`/`it` for comments).
  - **mini.pairs**: Autopair brackets and quotes (gated behind `kickstart-autopairs` category).
  - **mini.operators**: Replace (`gs`), exchange (`gX`), multiply (`gm`) operators.
  - **mini.surround**: Add/delete/replace surroundings (brackets, quotes, etc.). Default keybinds: `sa` (add), `sd` (delete), `sr` (replace).
  - **mini.statusline**: Simple statusline showing cursor position as `LINE:COL`.

### vim-move
- **Plugin**: `matze/vim-move`
- **Purpose**: Move lines and selections up/down.
- **Config**: `lua/plugins/editing/text-manipulation.lua`
- **Keybinds**: `<M-k>`/`<M-Up>` (move line up), `<M-j>`/`<M-Down>` (move line down). Same keys in visual mode for selections.

### vim-visual-multi
- **Plugin**: `mg979/vim-visual-multi`
- **Purpose**: Multi-cursor editing.
- **Config**: `lua/plugins/editing/text-manipulation.lua`
- **Keybinds**: `<C-M-k>`/`<C-M-Up>` (add cursor above), `<C-M-j>`/`<C-M-Down>` (add cursor below), `i`/`I` in visual mode (add cursors to selection).

### substitute.nvim
- **Plugin**: `gbprod/substitute.nvim`
- **Purpose**: Enhanced substitution and exchange operations.
- **Config**: `lua/plugins/editing/text-manipulation.lua`
- **Keybinds**: `s` (substitute via motion), `ss` (substitute line), `S` (substitute to EOL), `s` (visual: substitute selection), `sx` (exchange via motion), `sxx` (exchange line), `sxc` (cancel exchange), `X` (visual: exchange selection).

### switch.vim
- **Plugin**: `AndrewRadev/switch.vim`
- **Purpose**: Cycle/toggle words between predefined pairs (true/false, yes/no, enable/disable, etc.).
- **Config**: `lua/plugins/editing/text-manipulation.lua`
- **Keybinds**: `<leader>cs` (switch word), `<leader>cS` (switch reverse).

### vim-table-mode
- **Plugin**: `dhruvasagar/vim-table-mode`
- **Purpose**: Markdown table creation and alignment helper.
- **Config**: `lua/plugins/editing/text-manipulation.lua`
- **Keybinds**: `<leader>tt` (toggle table mode), `<leader>ta` (realign table).

### vim-characterize
- **Plugin**: `tpope/vim-characterize`
- **Purpose**: Enhanced `ga` command showing Unicode details for character under cursor.
- **Config**: `lua/plugins/editing/text-manipulation.lua`

### highlight-undo.nvim
- **Plugin**: `tzachar/highlight-undo.nvim`
- **Purpose**: Briefly highlights changed regions on undo/redo for visual feedback.
- **Config**: `lua/plugins/editing/text-manipulation.lua`

### nvim-ts-autotag
- **Plugin**: `windwp/nvim-ts-autotag`
- **Purpose**: Auto-close and auto-rename HTML/JSX tags using treesitter.
- **Config**: `lua/plugins/editing/autotag.lua`

### vim-matchup
- **Plugin**: `andymass/vim-matchup`
- **Purpose**: Enhanced `%` matching with treesitter integration. Shows matching pair in popup when offscreen.
- **Config**: `lua/plugins/editing/matchup.lua`

### vim-sleuth
- **Plugin**: `tpope/vim-sleuth`
- **Purpose**: Automatically detect tabstop and shiftwidth from file content.
- **Config**: `init.lua:168`

---

## Comments

### ts-comments.nvim
- **Plugin**: `folke/ts-comments.nvim`
- **Purpose**: Treesitter-aware commenting with `gc` mappings.
- **Config**: `init.lua:181`

### nvim-ts-context-commentstring
- **Plugin**: `JoosepAlviste/nvim-ts-context-commentstring`
- **Purpose**: Sets correct comment string based on treesitter context.
- **Config**: `lua/plugins/editing/comments.lua`

---

## UI Enhancements

### incline.nvim
- **Plugin**: `b0o/incline.nvim`
- **Purpose**: Floating filename labels in the top-right of each window, showing file icon, name, modified status, and top diagnostic.
- **Config**: `lua/plugins/ui/incline.lua`

### dropbar.nvim
- **Plugin**: `B0o/dropbar.nvim`
- **Purpose**: Breadcrumb-style winbar showing the current code context path.
- **Config**: `lua/plugins/ui/dropbar.lua`
- **Keybinds**: `<leader>wp` (pick symbol), `<leader>wm` (pick in current window).
- **Category**: Requires `general`.

### lensline.nvim
- **Plugin**: `camgraff/lensline.nvim`
- **Purpose**: Enhanced statusline integration with hlslens search match display.
- **Config**: `lua/plugins/ui/lensline.lua`
- **Dependencies**: `nvim-hlslens`.

### satellite.nvim
- **Plugin**: `lewis6991/satellite.nvim`
- **Purpose**: Scrollbar decorations showing search matches, diagnostics, git signs, and marks.
- **Config**: `lua/plugins/ui/satellite.lua`

### markview.nvim
- **Plugin**: `OXY2DEV/markview.nvim`
- **Purpose**: Rich markdown rendering in-buffer (headings, code blocks, tables, checkboxes, links, block quotes with callout support).
- **Config**: `lua/plugins/ui/markview.lua`
- **Category**: Requires `general`.

### nvim-colorizer.lua
- **Plugin**: `norcalli/nvim-colorizer.lua`
- **Purpose**: Inline color previews for hex codes, RGB, HSL, CSS colors, and Tailwind classes.
- **Config**: `lua/plugins/ui/colorizer.lua`

### rainbow-delimiters.nvim
- **Plugin**: `HiPhish/rainbow-delimiters.nvim`
- **Purpose**: Rainbow-colored matching brackets/delimiters using treesitter.
- **Config**: `lua/plugins/ui/rainbow-delimiters.lua`
- **Category**: Requires `general`.

### todo-comments.nvim
- **Plugin**: `folke/todo-comments.nvim`
- **Purpose**: Highlights TODO, FIXME, NOTE, HACK, WARN, etc. in comments.
- **Config**: `init.lua:991`

### reactive.nvim (Nix-packaged)
- **Plugin**: `rasulomaroff/reactive.nvim`
- **Purpose**: Dynamic mode-based highlights — changes cursorline, cursor, and mode message colors reactively based on the current Vim mode (normal, insert, visual, etc.).
- **Config**: `lua/plugins/ui/reactive.lua`
- **Commands**: `:ReactiveToggle`, `:ReactiveStop`, `:ReactiveStart`.
- **Notes**: Custom Nix-packaged plugin. Enables the built-in `cursorline`, `cursor`, and `modemsg` presets.

### no-neck-pain.nvim
- **Plugin**: `shortcuts/no-neck-pain.nvim`
- **Purpose**: Centers the active buffer for focused writing/coding.
- **Config**: `lua/plugins/general.lua`
- **Keybinds**: `<leader>tn` / `<leader>tc` (toggle center mode), `<leader>t+` (increase width), `<leader>t-` (decrease width).

---

## Code Minimap

### neominimap.nvim (Nix-packaged)
- **Plugin**: `Isrothy/neominimap.nvim`
- **Purpose**: Code minimap overlay showing a condensed view of the buffer with git changes, diagnostics, and search highlights.
- **Config**: `lua/plugins/ui/neoMiniMap.lua`
- **Keybinds**: `<leader>nt` (toggle), `<leader>ne` (enable), `<leader>nd` (disable), `<leader>nw` (toggle for window), `<leader>nr` (refresh), `<leader>nf` (focus), `<leader>nF` (unfocus).
- **Category**: Requires `general`.
- **Notes**: Custom Nix-packaged plugin. Floats at the right side of the window.

---

## Indent Guides

### indent-blankline.nvim + indent-rainbowline.nvim (Nix-packaged)
- **Plugins**: `lukas-reineke/indent-blankline.nvim` + `TheGLander/indent-rainbowline.nvim`
- **Purpose**: Rainbow-colored indent guide lines.
- **Config**: `lua/plugins/ui/indent-rainbowline.lua`
- **Keybinds**: `<leader>ti` (toggle indent guides).
- **Category**: Requires `general`.
- **Notes**: `indent-rainbowline.nvim` is a custom Nix-packaged plugin that adds color to indent-blankline.

---

## Diagnostics Display

### tiny-inline-diagnostic (Nix-managed)
- **Purpose**: Shows diagnostic messages inline with custom signs and multiline support.
- **Config**: `init.lua:1122`
- **Notes**: Loaded directly via `pcall(require, 'tiny-inline-diagnostic')` outside of lazy.nvim.

### spellwarn.nvim
- **Plugin**: `ravibrock/spellwarn.nvim`
- **Purpose**: Surfaces Vim spell-check results as LSP-style diagnostics.
- **Config**: `lua/plugins/tools/spellwarn.lua`

---

## Linting and Formatting

### nvim-lint
- **Plugin**: `mfussenegger/nvim-lint`
- **Purpose**: Asynchronous linter integration.
- **Config**: `lua/plugins/tools/lint.lua`
- **Configured linters**: `markdownlint` for markdown.
- **Category**: Requires `kickstart-lint`.

### conform.nvim
- **Plugin**: `stevearc/conform.nvim`
- **Purpose**: Formatter with format-on-save support.
- **Config**: `init.lua:825`
- **Configured formatters**: `stylua` for Lua.
- **Keybinds**: `<leader>f` (format buffer), `<leader>fm` (format buffer/region).

---

## Sessions and Persistence

### persistence.nvim
- **Plugin**: `folke/persistence.nvim`
- **Purpose**: Automatic session saving and restoring.
- **Config**: `lua/plugins/tools/sessions.lua`
- **Keybinds**: `<leader>qs` (restore session), `<leader>qS` (select session), `<leader>ql` (restore last session), `<leader>qd` (disable session saving).

---

## Notes / Writing

### neorg
- **Plugin**: `nvim-neorg/neorg`
- **Purpose**: Org-mode-like note taking and organization system with `.norg` file format.
- **Config**: `lua/plugins/neorg/init.lua`
- **Keybinds**: `<leader>mw` (open workspace), `<leader>mi` (open index), `<leader>mj` (journal today), `<leader>ms` (search notes).
- **Category**: Requires `neorg`.
- **Modules**: `core.defaults`, `core.concealer`, `core.summary`, `core.export`, `core.qol.todo_items`, `core.completion`, `core.integrations.nvim-cmp`, `core.journal`, `core.dirman`.

### obsidian.nvim
- **Plugin**: `epwalsh/obsidian.nvim`
- **Purpose**: Work with Obsidian vaults inside Neovim — wiki links, daily notes, backlinks, tags, and search.
- **Config**: `lua/plugins/obsidian/init.lua`
- **Keybinds**: `<leader>mon` (new note), `<leader>moo` (open in Obsidian app), `<leader>mos` (search), `<leader>moq` (quick switch), `<leader>mob` (backlinks), `<leader>mot` (tags), `<leader>mod` (daily note), `<leader>moy` (yesterday's note), `<leader>mol` (link selection, visual), `<leader>moL` (link to new note, visual).
- **Category**: Requires `obsidian`.
- **Features**: Multiple vault support via Nix config, daily notes, wiki-link completion via nvim-cmp, vault directory auto-creation.

---

## Database

### nvim-dbee
- **Plugin**: `kndndrj/nvim-dbee`
- **Purpose**: Database explorer and query executor.
- **Config**: `lua/plugins/tools/dbee.lua`
- **Keybinds**: `<leader>od` (toggle), `<leader>oD` (focus), `<leader>oe` (execute query).
- **DBee buffer keys**: `q` (close), `<CR>` (execute), `R` (refresh).

---

## Terminal and Scratch

Terminal and scratch functionality is provided by **snacks.nvim** (see [Core / Framework](#core--framework) section above).

- **Keybinds**: `<leader>ot` (float terminal), `<leader>os` (split terminal), `<C-]>` (exit terminal mode in snacks terminal), `<leader>ps` (scratch pad), `<leader>pS` (pick scratch).

---

## REPL Integration

### vim-slime
- **Plugin**: `jpalardy/vim-slime`
- **Purpose**: Send code to a REPL running in another terminal/pane (configured for Zellij).
- **Config**: `lua/plugins/tools/slime.lua`
- **Keybinds**: `<leader>cl` (send current line), `<leader>cr` (visual: send selection), `<leader>cc` (configure Slime target).

---

## Quality of Life

### myeyeshurt (Nix-packaged)
- **Plugin**: `wildfunctions/myeyeshurt`
- **Purpose**: Eye strain reminder that shows ASCII snowflakes after a configurable interval (20 minutes).
- **Config**: `lua/plugins/tools/myeyeshurt.lua`
- **Keybinds**: `<leader>ts` (start), `<leader>tx` (stop).
- **Category**: Requires `general`.
- **Notes**: Custom Nix-packaged plugin.

### precognition (Nix-managed)
- **Purpose**: Shows vim motion hints above the current line (w, b, e, W, B, E, ^, %, {, }).
- **Config**: `init.lua:1161`
- **Keybinds**: `<leader>tp` (toggle).
- **Notes**: Starts hidden; must be toggled on.

### hardtime.nvim (Nix-managed)
- **Purpose**: Discourages bad vim habits by blocking repeated h/j/k/l presses (max 3).
- **Config**: `init.lua:1199`
- **Keybinds**: `<leader>th` (toggle).
- **Notes**: Enabled by default. Arrow keys and scroll wheel are allowed.

---

## Custom Nix-Packaged Plugins Summary

These plugins are packaged via Nix rather than fetched by lazy.nvim:

| Plugin | Purpose | Config File |
|--------|---------|-------------|
| **myeyeshurt** | Eye strain break reminders | `lua/plugins/tools/myeyeshurt.lua` |
| **neominimap.nvim** | Code minimap overlay | `lua/plugins/ui/neoMiniMap.lua` |
| **indent-rainbowline.nvim** | Rainbow indent guide colors | `lua/plugins/ui/indent-rainbowline.lua` |
| **reactive.nvim** | Dynamic mode-based highlights | `lua/plugins/ui/reactive.lua` |

Additional Nix-managed plugins (loaded outside lazy.nvim):
- **tiny-inline-diagnostic** - Inline diagnostic display
- **precognition** - Vim motion hints
- **hardtime.nvim** - Bad habit blocker
- **copilot.vim** - GitHub Copilot
- **sidekick.nvim** - AI coding assistant
