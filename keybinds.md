# Keybinds

This document lists the keybinds explicitly set in this config. It does not include plugin defaults unless they are re-mapped here.

## Leader
- `SPC` is the global leader (`vim.g.mapleader = ' '`).
- `SPC` is also the local leader (`vim.g.maplocalleader = ' '`).

## General / Core
- Normal: `<Esc>` clears search highlight (and stops `hlslens` if available).
- Terminal: `<Esc>` exits terminal mode (`<C-\><C-n>`).
- Normal: `gx` opens the URL under cursor (falls back to system opener).
- Normal: `x` deletes a single character without yanking to a register.
- Normal: `SPC qq` quits all with confirmation (`:confirm qa`).

## Diagnostics (global)
- Normal: `[d` previous diagnostic.
- Normal: `]d` next diagnostic.
- Normal: `SPC de` show diagnostic float under cursor.
- Normal: `SPC dq` push diagnostics to loclist.

## Window Management
- Normal: `SPC w/` vertical split.
- Normal: `SPC w-` horizontal split.
- Normal: `SPC wc` close window.
- Normal: `SPC ww` cycle windows.
- Normal: `SPC wh/j/k/l` move focus left/down/up/right.
- Normal: `SPC wH/J/K/L` move window to left/down/up/right.
- Normal: `SPC wo` keep only current window.
- Normal: `SPC wf` toggle “focused” (maximized) window.

## File/Path Utilities
- Normal: `SPC fp` copy absolute file path to clipboard.
- Normal: `SPC fP` copy relative file path to clipboard.
- Normal: `SPC fe` open current file (or cwd) in system file manager.
- Normal: `SPC fr` open recent files (Telescope `oldfiles`).
- Normal: `SPC fs` save file (`:w`).

## File Browsing
- Normal: `SPC ft` toggle Neo-tree file tree.
- Normal: `SPC fo` toggle Oil file browser.

### Oil buffer (when inside Oil)
- `g?` help.
- `<CR>` open selection.
- `<C-s>` open in vertical split.
- `<C-h>` open in horizontal split.
- `<C-t>` open in new tab.
- `<C-p>` preview.
- `<C-c>` close Oil.
- `<C-l>` refresh.
- `-` go to parent directory.
- `_` open cwd.
- `` ` `` change directory to selection.
- `~` tab-local chdir to selection.
- `gs` change sort.
- `gx` open externally.
- `g.` toggle hidden files.
- `g\` toggle trash.

## Search / Telescope
- Normal: `SPC sh` search help tags.
- Normal: `SPC sk` search keymaps.
- Normal: `SPC sf` search files (Telescope `find_files`).
- Normal: `SPC ss` search in current buffer.
- Normal: `SPC sw` search current word.
- Normal: `SPC sg` live grep.
- Normal: `SPC sd` search diagnostics.
- Normal: `SPC sr` resume last picker.
- Normal: `SPC s.` recent files (Telescope `oldfiles`).
- Normal: `SPC st` list Telescope builtins.
- Normal: `SPC SPC` command palette (Telescope `commands`).
- Normal: `SPC /` fuzzy find in current buffer (dropdown, no preview).
- Normal: `SPC s/` live grep in open files.
- Normal: `SPC sn` find files in Neovim config.
- Normal: `SPC sp` live grep project including hidden files (excluding `.git`).
- Normal: `SPC sP` live grep project (standard).
- Normal: `SPC pp` recent projects picker (from recent files + git root).
- Normal: `SPC ff` find file with smart-open (fallback to built-in if extension fails).
- Normal: `SPC of` open file (Telescope built-in).
- Normal: `SPC fF` find files (Telescope built-in).
- Normal: `<C-S-f>` live grep whole project.

### hlslens-enhanced search motions
- Normal: `n` next search match (with lens).
- Normal: `N` previous search match (with lens).
- Normal: `*` search word under cursor (with lens).
- Normal: `#` search word backward (with lens).
- Normal: `g*` search partial word (with lens).
- Normal: `g#` search partial word backward (with lens).

### Project-wide replace (grug-far)
- Normal: `SPC sR` open replace UI (project).
- Normal: `SPC sW` open replace UI seeded with word under cursor.
- Visual: `SPC sR` open replace UI seeded with selection.

## Buffers
- Normal: `SPC bb` buffer picker (workspace).
- Normal: `SPC bB` buffer picker (all).
- Normal: `SPC ,` buffer picker (workspace).
- Normal: `SPC <S-,>` buffer picker (all).
- Normal: `SPC bc` close buffer (prompts to save if modified).
- Normal: `SPC bs` new scratch buffer.
- Normal: `SPC bu` reopen last buffer.
- Normal: `SPC bn` new buffer and enter insert mode.
- Normal: `[b` previous buffer (bufferline).
- Normal: `]b` next buffer (bufferline).
- Normal: `SPC bp` toggle buffer pin.
- Normal: `SPC bP` close unpinned buffers.
- Normal: `SPC bl` move current buffer to right window.
- Normal: `SPC bh` move current buffer to left window.
- Normal: `SPC bj` move current buffer to lower window.
- Normal: `SPC bk` move current buffer to upper window.

## Git
- Normal: `SPC gg` open Neogit.
- Normal: `SPC gdo` Diffview open.
- Normal: `SPC gdc` Diffview close.
- Normal: `SPC gdf` Diffview file history.
- Normal: `SPC gdt` Diffview toggle file panel.
- Normal: `]c` next git hunk.
- Normal: `[c` previous git hunk.
- Normal: `SPC gs` stage hunk.
- Normal: `SPC gr` reset hunk.
- Normal: `SPC gS` stage buffer.
- Normal: `SPC gu` undo stage hunk.
- Normal: `SPC gR` reset buffer.
- Normal: `SPC gp` preview hunk.
- Normal: `SPC gb` blame line.
- Normal: `SPC gd` diff against index.
- Normal: `SPC gD` diff against last commit.
- Visual: `SPC gs` stage selected hunk.
- Visual: `SPC gr` reset selected hunk.
- Normal: `SPC gtb` toggle current line blame.
- Normal: `SPC gtd` toggle deleted lines.
- Normal/Visual: `SPC gB` open file/selection in browser (snacks gitbrowse).
- Normal: `SPC gl` git blame line history (count-aware).

## LSP (buffer-local on LspAttach)
- Normal: `gd` go to definition (Telescope).
- Normal: `gr` go to references (Telescope).
- Normal: `gI` go to implementation (Telescope).
- Normal: `gD` go to declaration.
- Normal: `K` hover documentation.
- Normal: `SPC D` type definition (Telescope).
- Normal: `SPC ds` document symbols (Telescope).
- Normal: `SPC ws` workspace symbols (Telescope).
- Normal: `SPC lr` rename symbol.
- Normal: `SPC la` code action.
- Normal: `SPC ti` toggle inlay hints (only if server supports).

## LSP / Code Actions (custom keymap layer)
- Normal: `SPC ;` toggle comment for current line (ts-comments).
- Visual: `SPC ;` toggle comment for selection.
- Normal: `SPC cc` run `:make`.
- Normal: `SPC cd` jump to definition (LSP direct).
- Normal: `SPC cr` find references (LSP direct).
- Normal: `SPC ck` hover docs (LSP direct).
- Normal: `SPC cR` rename symbol (floating prompt).
- Normal: `SPC cp` send to REPL (currently unconfigured; shows notice).
- Normal: `SPC cx` open diagnostics float.
- Normal: `SPC ct` type definition.
- Normal: `SPC co` organize imports (applies action).
- Normal: `SPC cw` remove trailing whitespace.
- Normal: `SPC cW` remove trailing newlines.
- Normal: `SPC ce` next diagnostic.
- Normal: `SPC cE` previous diagnostic.
- Normal: `]e` next error-level diagnostic.
- Normal: `[e` previous error-level diagnostic.
- Normal: `]w` next warning-level diagnostic.
- Normal: `[w` previous warning-level diagnostic.
- Normal: `]h` next hint-level diagnostic.
- Normal: `[h` previous hint-level diagnostic.

## Formatting
- Normal: `SPC fm` format buffer.
- Visual: `SPC fm` format selection.

## Error List (Trouble)
- Normal: `SPC ee` toggle diagnostics list.
- Normal: `SPC ef` code action for fix.
- Normal: `SPC el` toggle diagnostics list (current buffer only).
- Normal: `SPC en` next error.
- Normal: `SPC eN` previous error.
- Normal: `SPC ep` previous error.

## Debugging (DAP)
- Normal: `<F5>` start/continue.
- Normal: `<F1>` step into.
- Normal: `<F2>` step over.
- Normal: `<F3>` step out.
- Normal: `<F7>` toggle DAP UI (show last session result).
- Normal: `SPC db` toggle breakpoint.
- Normal: `SPC dB` set conditional breakpoint.
- Normal: `SPC dl` run last.
- Normal: `SPC dr` toggle REPL.
- Normal: `SPC dc` continue.
- Normal/Visual: `SPC de` evaluate under cursor/selection (DAP UI).
- Normal: `SPC dx` terminate session + close UI.
- In DAP REPL/UI buffers: `q` closes the window.

## Terminal / Scratch / Notifications (snacks.nvim)
- Normal: `SPC ot` toggle floating terminal.
- Normal/Terminal: `SPC os` toggle split terminal.
- Terminal: `<C-]>` exit terminal mode (snacks terminal style).
- Normal: `SPC ps` toggle scratch buffer.
- Normal: `SPC pS` pick scratch buffer.
- Normal: `SPC pn` notifications history.
- Normal: `SPC pd` open dashboard.
- Normal: `SPC bd` delete buffer.
- Normal: `SPC bD` force delete buffer.
- Normal: `SPC bb` open buffers picker (snacks).

## Jump / Navigation
- Normal/Visual/Operator: `SPC jw` jump to word (flash).
- Normal/Visual/Operator: `SPC jt` jump to treesitter node (flash).
- Normal: `SPC jf` jump to another window (UI picker).
- Normal: `SPC jtf` jump to function/method via treesitter.
- Normal: `SPC jtc` jump to class/struct via treesitter.
- Normal: `SPC jtb` jump to loop/conditional via treesitter.
- Operator: `SPC jr` remote flash.
- Operator/Visual: `SPC jR` treesitter search.
- Normal: `SPC jl` jump to line (prompt).
- Normal: `SPC jC` jump to previous change (`g;`).
- Normal: `SPC jc` jump to next change (`g,`).
- Normal: `]r` next reference (illuminate).
- Normal: `[r` previous reference (illuminate).

## Text Editing / Manipulation
- Normal: `<M-k>` move line up.
- Normal: `<M-j>` move line down.
- Normal: `<M-Up>` move line up.
- Normal: `<M-Down>` move line down.
- Visual: `<M-k>` move selection up.
- Visual: `<M-j>` move selection down.
- Visual: `<M-Up>` move selection up.
- Visual: `<M-Down>` move selection down.
- Normal: `<C-M-k>` add multicursor above.
- Normal: `<C-M-j>` add multicursor below.
- Normal: `<C-M-Up>` add multicursor above.
- Normal: `<C-M-Down>` add multicursor below.
- Visual: `i` add cursors to selection.
- Visual: `I` add cursors to selection.
- Normal: `s` substitute via motion.
- Normal: `ss` substitute line.
- Normal: `S` substitute to end of line.
- Visual: `s` substitute selection.
- Normal: `sx` exchange via motion.
- Normal: `sxx` exchange line.
- Normal: `sxc` cancel exchange.
- Visual: `X` exchange selection.
- Normal: `SPC cs` switch word (cycle).
- Normal: `SPC cS` switch word (reverse).
- Visual: `SPC cs` switch selection (cycle).
- Visual: `SPC cS` switch selection (reverse).
- Normal: `SPC tt` toggle table mode.
- Normal: `SPC ta` realign table.

## AI / Assistants
- Insert: `<Tab>` accept Sidekick “next edit” or Copilot suggestion.
- Normal: `SPC cT` toggle Copilot for current buffer.
- Normal: `SPC an` apply next Sidekick edit suggestion.
- Normal: `SPC aN` toggle Sidekick next edit suggestions.
- Normal/Visual: `SPC aa` toggle Sidekick CLI.
- Normal/Visual: `SPC ap` prompt Sidekick CLI.
- Visual: `SPC as` send selection to Sidekick CLI.
- Normal/Visual/Insert/Terminal: `SPC af` focus Sidekick CLI window.

## Notes / Writing
- Normal: `SPC mw` open Neorg default workspace.
- Normal: `SPC mi` open Neorg index.
- Normal: `SPC mj` open Neorg journal (today).
- Normal: `SPC ms` search Neorg notes (Telescope).

## Database
- Normal: `SPC od` toggle DBee explorer.
- Normal: `SPC oD` focus DBee explorer.
- Normal: `SPC oe` execute query (DBee).

## Sessions / Persistence
- Normal: `SPC qs` restore session.
- Normal: `SPC qS` select session.
- Normal: `SPC ql` restore last session.
- Normal: `SPC qd` stop persistence (disable session saving).

## UI / Quality of Life Toggles
- Normal: `SPC nt` toggle minimap.
- Normal: `SPC ne` enable minimap.
- Normal: `SPC nd` disable minimap.
- Normal: `SPC nw` toggle minimap for current window.
- Normal: `SPC nr` refresh minimap.
- Normal: `SPC nf` focus minimap.
- Normal: `SPC nF` unfocus minimap.
- Normal: `SPC ts` start eye break reminder.
- Normal: `SPC tx` stop eye break reminder.
- Normal: `SPC tp` toggle precognition hints.
- Normal: `SPC th` toggle hardtime.
- Normal: `SPC ti` toggle indent guides.
- Normal: `SPC tc` toggle treesitter context.
- Normal: `SPC tn` toggle No-Neck-Pain center mode.
- Normal: `SPC tc` toggle No-Neck-Pain center mode.
- Normal: `SPC t+` increase No-Neck-Pain width by 5.
- Normal: `SPC t-` decrease No-Neck-Pain width by 5.
- Normal: `SPC wp` pick winbar symbol (dropbar).
- Normal: `SPC wm` pick winbar symbol in current window (dropbar).
- Normal: `SPC wt` toggle workspace marks (arrow.nvim).
- Normal: `SPC wn` next workspace mark.
- Normal: `SPC wp` previous workspace mark.
- Normal: `SPC wm` open workspace mark menu.
- Normal: `SPC w1`..`SPC w9` jump to workspace mark 1..9.

## Conflicts / Overlaps to be aware of
- `SPC ti` is used for both LSP inlay hints (buffer-local, if supported) and indent guides.
- `SPC tc` is used for both treesitter-context toggle and No-Neck-Pain toggle.
- `SPC wp` and `SPC wm` are used by both dropbar and arrow.nvim.
- `SPC bb` is used by both Telescope buffer picker and snacks buffer picker.
- `SPC de` is used for diagnostics float (core) and DAP eval (debug).
- `SPC cc` is used for `:make` (LSP layer) and Slime config.
