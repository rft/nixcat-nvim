# Keybind Reference

Comprehensive keybind reference for nixcat-nvim. This documents every explicitly configured keybind across all config files.

## Leader Key

- **Leader**: `<Space>` (`vim.g.mapleader = ' '`)
- **Local Leader**: `<Space>` (`vim.g.maplocalleader = ' '`)

`SPC` is used as shorthand for `<Space>` (leader) throughout this document.

## Leader Prefix Groups

| Prefix | Group | Purpose |
|--------|-------|---------|
| `SPC a` | **[A]I** | AI assistants (Sidekick, Copilot) |
| `SPC b` | **[B]uffer** | Buffer operations |
| `SPC c` | **[C]ode** | Code actions, LSP operations |
| `SPC d` | **[D]ebug/Document** | Debugging and document operations |
| `SPC e` | **[E]rror** | Error/diagnostics list |
| `SPC f` | **[F]ile** | File operations |
| `SPC g` | **[G]it** | Git operations |
| `SPC j` | **[J]ump** | Jump/navigation |
| `SPC l` | **[L]SP** | LSP-specific actions |
| `SPC m` | **[M]notes** | Neorg notes |
| `SPC n` | **[N]eominimap** | Code minimap |
| `SPC o` | **[O]pen** | Open tools/panels |
| `SPC p` | **[P]roject** | Project operations |
| `SPC q` | **[Q]uick/quit** | Session/quit |
| `SPC r` | **[R]ename** | Rename operations |
| `SPC s` | **[S]earch** | Search/find |
| `SPC t` | **[T]oggle** | UI toggles |
| `SPC w` | **[W]indow** | Window management |

---

## General / Core

Source: `lua/core/keymaps.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `<Esc>` | Clear search + hlslens | Clear search highlighting |
| t | `<Esc>` | `<C-\><C-n>` | Exit terminal mode |
| n | `gx` | Open URL | Open URL under cursor in browser |
| n | `x` | `"_x` | Delete character without yanking |
| n | `SPC qq` | `:confirm qa` | Quit all with confirmation |

---

## Window Management

Source: `lua/core/keymaps.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC w/` | `<C-w>v` | Split window vertically |
| n | `SPC w-` | `<C-w>s` | Split window horizontally |
| n | `SPC wc` | `<C-w>c` | Close window |
| n | `SPC ww` | `<C-w>w` | Cycle to next window |
| n | `SPC wh` | `<C-w>h` | Move focus to left window |
| n | `SPC wj` | `<C-w>j` | Move focus to lower window |
| n | `SPC wk` | `<C-w>k` | Move focus to upper window |
| n | `SPC wl` | `<C-w>l` | Move focus to right window |
| n | `SPC wH` | `<C-w>H` | Move window to far left |
| n | `SPC wJ` | `<C-w>J` | Move window to bottom |
| n | `SPC wK` | `<C-w>K` | Move window to top |
| n | `SPC wL` | `<C-w>L` | Move window to far right |
| n | `SPC wo` | `<C-w>o` | Keep only current window |
| n | `SPC wf` | toggle_window_focus | Toggle maximized/equalized window |

---

## File Operations

Sources: `lua/core/keymaps.lua`, `lua/plugins/general.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC fp` | Copy path | Copy absolute file path to clipboard |
| n | `SPC fP` | Copy path | Copy relative file path to clipboard |
| n | `SPC fe` | Open explorer | Open current file in system file manager |
| n | `SPC fr` | Snacks picker recent | Open recent files |
| n | `SPC fs` | `:w` | Save file |
| n | `SPC ft` | `:Neotree toggle` | Toggle Neo-tree file tree |
| n | `SPC fo` | Oil toggle | Toggle Oil file browser |
| n | `SPC ff` | Snacks picker smart | Find file (smart) |
| n | `SPC fF` | Snacks picker files | Find files |
| n | `SPC of` | Snacks picker files | Open file |
| n | `SPC ou` | `:UndotreeToggle` | Toggle undo tree |

### Oil Buffer Keymaps (inside Oil)

| Key | Action |
|-----|--------|
| `g?` | Show help |
| `<CR>` | Open selection |
| `<C-s>` | Open in vertical split |
| `<C-h>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview |
| `<C-c>` | Close Oil |
| `<C-l>` | Refresh |
| `-` | Go to parent directory |
| `_` | Open cwd |
| `` ` `` | Change directory |
| `~` | Tab-local chdir |
| `gs` | Change sort |
| `gx` | Open externally |
| `g.` | Toggle hidden files |
| `g\` | Toggle trash |

### Neo-tree Buffer Keymaps

| Key | Action | Context |
|-----|--------|---------|
| `\` | Close window | Filesystem |
| `bd` | Delete buffer | Buffers |
| `<BS>` | Navigate up | Buffers |
| `.` | Set root | Buffers |
| `A` | Git add all | Git status |
| `gu` | Unstage file | Git status |
| `ga` | Add file | Git status |
| `gr` | Revert file | Git status |
| `gc` | Commit | Git status |
| `gp` | Push | Git status |
| `gg` | Commit and push | Git status |

---

## Search / Picker

Source: `lua/plugins/tools/snacks.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC sh` | Snacks picker help | Search help tags |
| n | `SPC sk` | Snacks picker keymaps | Search keymaps |
| n | `SPC sf` | Snacks picker files | Search files |
| n | `SPC ss` | Snacks picker lines | Search in current file |
| n | `SPC sw` | Snacks picker grep_word | Search current word |
| n | `SPC sg` | Snacks picker grep | Live grep |
| n | `SPC sd` | Snacks picker diagnostics | Search diagnostics |
| n | `SPC sr` | Snacks picker resume | Resume last picker |
| n | `SPC s.` | Snacks picker recent | Search recent files |
| n | `SPC st` | Snacks picker pickers | List all pickers |
| n | `SPC SPC` | Snacks picker commands | Command palette |
| n | `SPC /` | Snacks picker lines | Fuzzy search current buffer |
| n | `SPC s/` | Snacks picker grep_buffers | Grep in open files only |
| n | `SPC sn` | Snacks picker files | Search Neovim config files |
| n | `SPC sp` | Snacks picker grep | Project grep including hidden files |
| n | `SPC sP` | Snacks picker grep | Project grep (standard) |
| n | `SPC pp` | Snacks picker projects | Projects picker |
| n | `<C-S-f>` | Snacks picker grep | Search whole project |

### Search & Replace (grug-far)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC sR` | grug-far open | Project-wide search & replace |
| n | `SPC sW` | grug-far open | Search & replace with word under cursor |
| v | `SPC sR` | grug-far open | Search & replace with visual selection |

### Search Motions (hlslens-enhanced)

| Mode | Key | Description |
|------|-----|-------------|
| n | `n` | Next search match (with lens) |
| n | `N` | Previous search match (with lens) |
| n | `*` | Search word under cursor (with lens) |
| n | `#` | Search word backward (with lens) |
| n | `g*` | Search partial word (with lens) |
| n | `g#` | Search partial word backward (with lens) |

---

## Buffers

Sources: `lua/plugins/tools/snacks.lua`, `lua/plugins/ui/buffers.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC bb` | Snacks picker buffers | Browse open buffers |
| n | `SPC bB` | Snacks picker buffers | Buffer picker (all) |
| n | `SPC ,` | Snacks picker buffers | Buffer picker (workspace) |
| n | `SPC <S-,>` | Snacks picker buffers | Buffer picker (all) |
| n | `SPC bc` | Custom function | Close buffer (prompts to save if modified) |
| n | `SPC bs` | `:enew` | New scratch buffer |
| n | `SPC bu` | `:e #` | Reopen last buffer |
| n | `SPC bn` | New + insert | New buffer and enter insert mode |
| n | `SPC bd` | Snacks bufdelete | Delete buffer |
| n | `SPC bD` | Snacks bufdelete | Force delete buffer |
| n | `[b` | BufferLine cycle prev | Previous buffer |
| n | `]b` | BufferLine cycle next | Next buffer |
| n | `SPC bp` | BufferLine toggle pin | Toggle buffer pin |
| n | `SPC bP` | BufferLine group close | Close unpinned buffers |
| n | `SPC bl` | Move to right window | Move buffer to right window |
| n | `SPC bh` | Move to left window | Move buffer to left window |
| n | `SPC bj` | Move to lower window | Move buffer to lower window |
| n | `SPC bk` | Move to upper window | Move buffer to upper window |

---

## Diagnostics

Source: `lua/core/keymaps.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `[d` | diagnostic.goto_prev | Previous diagnostic |
| n | `]d` | diagnostic.goto_next | Next diagnostic |
| n | `SPC de` | diagnostic.open_float | Show diagnostic float |
| n | `SPC dq` | diagnostic.setloclist | Send diagnostics to location list |

---

## LSP (buffer-local on LspAttach)

Source: `init.lua` (LspAttach autocmd)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `gd` | Snacks picker lsp_definitions | Go to definition |
| n | `gr` | Snacks picker lsp_references | Go to references |
| n | `gI` | Snacks picker lsp_implementations | Go to implementation |
| n | `gD` | lsp.buf.declaration | Go to declaration |
| n | `K` | lsp.buf.hover | Hover documentation |
| n | `SPC D` | Snacks picker lsp_type_definitions | Type definition |
| n | `SPC ds` | Snacks picker lsp_symbols | Document symbols |
| n | `SPC ws` | Snacks picker lsp_workspace_symbols | Workspace symbols |
| n | `SPC lr` | lsp.buf.rename | LSP rename |
| n | `SPC la` | lsp.buf.code_action | LSP code action |
| n | `SPC ti` | Toggle inlay hints | Toggle LSP inlay hints |

---

## Code Actions / LSP Keymap Layer

Source: `lua/plugins/lsp.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC ;` | Toggle comment | Comment out current line |
| x | `SPC ;` | Toggle comment | Comment out selection |
| n | `SPC cc` | `:make` | Compile |
| n | `SPC cd` | lsp.buf.definition | Jump to definition |
| n | `SPC cr` | lsp.buf.references | Find references |
| n | `SPC ck` | lsp.buf.hover | Hover documentation |
| n | `SPC cR` | Floating rename | Rename symbol (custom floating prompt) |
| n | `SPC cp` | (notice) | Send to REPL (unconfigured) |
| n | `SPC cx` | diagnostic.open_float | Open diagnostics float |
| n | `SPC ct` | lsp.buf.type_definition | Type definition |
| n | `SPC co` | Code action (filter) | Organize imports |
| n | `SPC cw` | `:%s/\s\+$//e` | Remove trailing whitespace |
| n | `SPC cW` | `:%s/\n\+\%$//e` | Remove trailing newlines |
| n | `SPC ce` | diagnostic.goto_next | Next diagnostic |
| n | `SPC cE` | diagnostic.goto_prev | Previous diagnostic |
| n | `]e` | diagnostic.goto_next (ERROR) | Next error |
| n | `[e` | diagnostic.goto_prev (ERROR) | Previous error |
| n | `]w` | diagnostic.goto_next (WARN) | Next warning |
| n | `[w` | diagnostic.goto_prev (WARN) | Previous warning |
| n | `]h` | diagnostic.goto_next (HINT) | Next hint |
| n | `[h` | diagnostic.goto_prev (HINT) | Previous hint |

---

## Formatting

Sources: `init.lua`, `lua/plugins/general.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| any | `SPC f` | conform.format | Format buffer (conform.nvim) |
| n | `SPC fm` | lsp.buf.format | Format buffer (LSP) |
| v | `SPC fm` | lsp.buf.format | Format selection (LSP) |

---

## Error List (Trouble)

Source: `lua/plugins/errors.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC ee` | Trouble diagnostics toggle | Toggle diagnostics list |
| n | `SPC ef` | lsp.buf.code_action | Fix error (code action) |
| n | `SPC el` | Trouble diagnostics (buf=0) | Toggle buffer diagnostics |
| n | `SPC en` | Trouble next | Next error |
| n | `SPC eN` | Trouble prev | Previous error |
| n | `SPC ep` | Trouble prev | Previous error |

---

## Git

Sources: `lua/plugins/git.lua`, `lua/plugins/snacks.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC gg` | `:Neogit` | Open Neogit |
| n | `SPC gdo` | `:DiffviewOpen` | Diffview open |
| n | `SPC gdc` | `:DiffviewClose` | Diffview close |
| n | `SPC gdf` | `:DiffviewFileHistory` | Diffview file history |
| n | `SPC gdt` | `:DiffviewToggleFiles` | Diffview toggle files panel |
| n | `]c` | Gitsigns nav_hunk next | Next git hunk |
| n | `[c` | Gitsigns nav_hunk prev | Previous git hunk |
| n | `SPC gs` | Gitsigns stage_hunk | Stage hunk |
| v | `SPC gs` | Gitsigns stage_hunk | Stage selected hunk |
| n | `SPC gr` | Gitsigns reset_hunk | Reset hunk |
| v | `SPC gr` | Gitsigns reset_hunk | Reset selected hunk |
| n | `SPC gS` | Gitsigns stage_buffer | Stage entire buffer |
| n | `SPC gu` | Gitsigns undo_stage_hunk | Undo stage hunk |
| n | `SPC gR` | Gitsigns reset_buffer | Reset entire buffer |
| n | `SPC gp` | Gitsigns preview_hunk | Preview hunk |
| n | `SPC gb` | Gitsigns blame_line | Blame current line |
| n | `SPC gd` | Gitsigns diffthis | Diff against index |
| n | `SPC gD` | Gitsigns diffthis('@') | Diff against last commit |
| n | `SPC gtb` | Gitsigns toggle_current_line_blame | Toggle line blame |
| n | `SPC gtd` | Gitsigns toggle_deleted | Toggle deleted lines |
| n,v | `SPC gB` | Snacks gitbrowse | Open file/selection in browser |
| n | `SPC gl` | Snacks git blame_line | Blame line history (count-aware) |

---

## Debugging (DAP)

Source: `lua/plugins/debug.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `<F5>` | dap.continue | Start/Continue |
| n | `<F1>` | dap.step_into | Step into |
| n | `<F2>` | dap.step_over | Step over |
| n | `<F3>` | dap.step_out | Step out |
| n | `<F7>` | dapui.toggle | Toggle DAP UI |
| n | `SPC db` | dap.toggle_breakpoint | Toggle breakpoint |
| n | `SPC dB` | dap.set_breakpoint | Set conditional breakpoint (prompts) |
| n | `SPC dl` | dap.run_last | Run last debug config |
| n | `SPC dr` | dap.repl.toggle | Toggle REPL |
| n | `SPC dc` | dap.continue | Continue |
| n,v | `SPC de` | dapui.eval | Evaluate under cursor/selection |
| n | `SPC dx` | dap.terminate + dapui.close | Terminate session and close UI |
| n | `SPC du` | dapui.toggle | Toggle debug UI |

In DAP REPL/UI buffers:

| Key | Action |
|-----|--------|
| `q` | Close the window |

---

## Jump / Navigation

Sources: `lua/plugins/jump.lua`, `lua/plugins/illuminate.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n,x,o | `SPC jw` | flash.jump | Jump to word (flash labels) |
| n,x,o | `SPC jt` | flash.treesitter | Jump to treesitter node |
| n | `SPC jf` | vim.ui.select | Jump to another window (picker) |
| n,x,o | `SPC jtf` | flash.treesitter | Jump to function/method |
| n,x,o | `SPC jtc` | flash.treesitter | Jump to class/struct |
| n,x,o | `SPC jtb` | flash.treesitter | Jump to loop/conditional |
| o | `SPC jr` | flash.remote | Remote flash |
| o,x | `SPC jR` | flash.treesitter_search | Treesitter search |
| n | `SPC jl` | Go to line (prompt) | Jump to specific line number |
| n | `SPC jC` | `g;` | Jump to previous change |
| n | `SPC jc` | `g,` | Jump to next change |
| n | `]r` | illuminate goto_next_reference | Next reference |
| n | `[r` | illuminate goto_prev_reference | Previous reference |

### Scope Jumps (snacks.nvim)

| Mode | Key | Description |
|------|-----|-------------|
| n | `[i` | Jump to upper scope edge |
| n | `]i` | Jump to lower scope edge |
| textobj | `ii` | Inner scope |
| textobj | `ai` | Around scope |

---

## Text Editing / Manipulation

Sources: `lua/plugins/text-manipulation.lua`, `init.lua` (mini.nvim)

### Line/Block Movement

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `<M-k>` / `<M-Up>` | MoveLineUp | Move line up |
| n | `<M-j>` / `<M-Down>` | MoveLineDown | Move line down |
| v | `<M-k>` / `<M-Up>` | MoveBlockUp | Move selection up |
| v | `<M-j>` / `<M-Down>` | MoveBlockDown | Move selection down |

### Multi-cursor

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `<C-M-k>` / `<C-M-Up>` | VM-Add-Cursor-Up | Add cursor above |
| n | `<C-M-j>` / `<C-M-Down>` | VM-Add-Cursor-Down | Add cursor below |
| x | `i` / `I` | VM-Visual-Cursors | Add cursors to visual selection |

### Substitution / Exchange

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `s` | substitute.operator | Substitute via motion |
| n | `ss` | substitute.line | Substitute entire line |
| n | `S` | substitute.eol | Substitute to end of line |
| x | `s` | substitute.visual | Substitute selection |
| n | `sx` | exchange.operator | Exchange via motion |
| n | `sxx` | exchange.line | Exchange entire line |
| n | `sxc` | exchange.cancel | Cancel pending exchange |
| x | `X` | exchange.visual | Exchange selection |

### Word Switching

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC cs` | `:Switch` | Cycle word (true/false, yes/no, etc.) |
| n | `SPC cS` | `:SwitchReverse` | Cycle word (reverse) |
| v | `SPC cs` | `:Switch` | Cycle selection |
| v | `SPC cS` | `:SwitchReverse` | Cycle selection (reverse) |

### Table Mode

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC tt` | `:TableModeToggle` | Toggle table mode |
| n | `SPC ta` | `:TableModeRealign` | Realign table |

### Surround (mini.surround)

| Mode | Key | Description |
|------|-----|-------------|
| n | `sa{motion}{char}` | Add surrounding |
| n | `sd{char}` | Delete surrounding |
| n | `sr{old}{new}` | Replace surrounding |

### Operators (mini.operators)

| Mode | Key | Description |
|------|-----|-------------|
| n | `gs{motion}` | Replace with register content |
| n | `gX{motion}` | Exchange regions |
| n | `gm{motion}` | Multiply (duplicate) text |

---

## AI / Assistants

Sources: `lua/plugins/copilot.lua`, `lua/plugins/sidekick.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| i | `<Tab>` | Accept suggestion | Accept Sidekick NES or Copilot suggestion |
| n | `SPC cT` | `:Copilot toggle` | Toggle Copilot for current buffer |
| n | `SPC an` | sidekick.nes_jump_or_apply | Apply next Sidekick edit suggestion |
| n | `SPC aN` | sidekick.nes.toggle | Toggle Sidekick next edit suggestions |
| n,v | `SPC aa` | sidekick.cli.toggle | Toggle Sidekick CLI |
| n,v | `SPC ap` | sidekick.cli.prompt | Prompt Sidekick CLI |
| v | `SPC as` | sidekick.cli.send | Send visual selection to Sidekick CLI |
| n,x,i,t | `SPC af` | sidekick.cli.focus | Focus Sidekick CLI window |

---

## Notes / Writing (Neorg)

Source: `lua/plugins/neorg/init.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC mw` | Neorg workspace | Open default Neorg workspace |
| n | `SPC mi` | Neorg index | Open Neorg workspace index |
| n | `SPC mj` | Neorg journal today | Open today's journal entry |
| n | `SPC ms` | Snacks picker (norg files) | Search Neorg notes |

---

## Database

Source: `lua/plugins/dbee.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC od` | dbee.toggle | Toggle database explorer |
| n | `SPC oD` | dbee.focus | Focus database explorer |
| n | `SPC oe` | DBeeExecute | Execute query |

---

## REPL (vim-slime)

Source: `lua/plugins/slime.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC cl` | SlimeSendCurrentLine | Send current line to REPL |
| v | `SPC cr` | SlimeSend | Send visual selection to REPL |
| n | `SPC cc` | SlimeConfig | Configure Slime target |

**Note**: Slime is configured for Zellij as the target multiplexer.

---

## Sessions / Persistence

Source: `lua/plugins/sessions.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC qs` | persistence.load | Restore session for current directory |
| n | `SPC qS` | persistence.select | Select and restore a session |
| n | `SPC ql` | persistence.load (last) | Restore last session |
| n | `SPC qd` | persistence.stop | Disable session saving |

---

## Terminal / Scratch / Notifications

Source: `lua/plugins/snacks.lua`

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC ot` | Snacks terminal (float) | Toggle floating terminal |
| n,t | `SPC os` | Snacks terminal (split) | Toggle split terminal (bottom) |
| t | `<C-]>` | `<C-\><C-n>` | Exit terminal mode (snacks style) |
| n | `SPC ps` | Snacks scratch | Toggle scratch buffer |
| n | `SPC pS` | Snacks scratch.select | Pick scratch buffer |
| n | `SPC pn` | Snacks notifier history | Show notification history |
| n | `SPC pd` | Snacks dashboard | Open dashboard |

---

## UI / Quality of Life Toggles

Sources: `lua/plugins/neoMiniMap.lua`, `lua/plugins/myeyeshurt.lua`, `init.lua`, `lua/plugins/indent-rainbowline.lua`, `lua/plugins/treesitter-context.lua`, `lua/plugins/general.lua`, `lua/plugins/dropbar.lua`, `lua/plugins/arrow.lua`

### Minimap

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC nt` | Neominimap Toggle | Toggle minimap |
| n | `SPC ne` | Neominimap Enable | Enable minimap |
| n | `SPC nd` | Neominimap Disable | Disable minimap |
| n | `SPC nw` | Neominimap WinToggle | Toggle minimap for current window |
| n | `SPC nr` | Neominimap Refresh | Refresh minimap |
| n | `SPC nf` | Neominimap Focus | Focus minimap |
| n | `SPC nF` | Neominimap Unfocus | Unfocus minimap |

### UI Toggles

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC ts` | myeyeshurt.start | Start eye break reminder |
| n | `SPC tx` | myeyeshurt.stop | Stop eye break reminder |
| n | `SPC tp` | precognition.toggle | Toggle vim motion hints |
| n | `SPC th` | hardtime.toggle | Toggle hardtime (bad habit blocker) |
| n | `SPC ti` | ibl.toggle | Toggle indent guides |
| n | `SPC tc` | treesitter-context.toggle | Toggle treesitter context |
| n | `SPC tn` | NoNeckPain | Toggle center mode (No Neck Pain) |
| n | `SPC tc` | NoNeckPain | Toggle center mode (alias) |
| n | `SPC t+` | NoNeckPain resize | Increase center width by 5 |
| n | `SPC t-` | NoNeckPain resize | Decrease center width by 5 |

### Winbar / Dropbar

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC wp` | dropbar.api.pick | Pick winbar symbol |
| n | `SPC wm` | dropbar.api.pick (current) | Pick symbol in current window |

### Workspace Marks (Arrow)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| n | `SPC wt` | arrow.persist.toggle | Toggle workspace mark on file |
| n | `SPC wn` | arrow.persist.next | Next workspace mark |
| n | `SPC wp` | arrow.persist.previous | Previous workspace mark |
| n | `SPC wm` | arrow.ui.openMenu | Open workspace marks menu |
| n | `SPC w1`..`SPC w9` | arrow.persist.go_to(n) | Jump to workspace mark 1-9 |

---

## Completion (Insert Mode)

Source: `init.lua` (nvim-cmp)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| i | `<M-Down>` | cmp.select_next_item | Next completion item |
| i | `<M-Up>` | cmp.select_prev_item | Previous completion item |
| i | `<C-b>` | cmp.scroll_docs(-4) | Scroll docs up |
| i | `<C-f>` | cmp.scroll_docs(4) | Scroll docs down |
| i | `<CR>` | cmp.confirm | Accept completion |
| i | `<C-Space>` | cmp.complete | Trigger completion manually |
| i,s | `<C-l>` | luasnip.expand_or_jump | Snippet jump forward |
| i,s | `<C-h>` | luasnip.jump(-1) | Snippet jump backward |

---

## Reactive Highlights

Source: `lua/plugins/ui/reactive.lua`

reactive.nvim provides automatic mode-based highlight changes (cursorline, cursor, mode message). No keybinds needed — it reacts to mode changes automatically.

**Commands**: `:ReactiveToggle`, `:ReactiveStop`, `:ReactiveStart`.

---

## Known Conflicts / Overlaps

Some keybinds are used by multiple plugins. In practice, the last one to set the keymap wins, or buffer-local mappings take precedence:

| Keybind | Conflict | Notes |
|---------|----------|-------|
| `SPC ti` | LSP inlay hints vs indent guides | LSP version is buffer-local (takes precedence when LSP attached) |
| `SPC tc` | Treesitter context vs No-Neck-Pain | Both set globally; last loaded wins |
| `SPC wp` | Dropbar pick vs Arrow previous mark | Both set globally; last loaded wins |
| `SPC wm` | Dropbar pick (current) vs Arrow menu | Both set globally; last loaded wins |
| `SPC de` | Diagnostics float vs DAP eval | DAP version is buffer-local in debug mode |
| `SPC cc` | `:make` (lsp.lua) vs Slime config | Both set globally; last loaded wins |
| `SPC cr` | LSP references (lsp.lua) vs Slime send (visual) | Different modes (normal vs visual) |
