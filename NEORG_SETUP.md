# Neorg Configuration with Doom Emacs-like Keybinds

This configuration sets up Neorg with keybindings inspired by Doom Emacs org-mode for a familiar and efficient note-taking experience.

## Features

- Doom Emacs-style keybindings (`<leader>n*`, `<leader>m*`, etc.)
- Comprehensive task management
- Multiple workspaces support
- Beautiful icons and concealing
- Integration with which-key for discoverable keybinds

## Workspaces

Three predefined workspaces are available:
- `~/notes` - General notes (default)
- `~/work-notes` - Work-related notes
- `~/personal-notes` - Personal notes

## Key Bindings

### Navigation & Workspaces (`<leader>n`)
- `<leader>nn` - Open notes workspace
- `<leader>nw` - Open work workspace
- `<leader>np` - Open personal workspace
- `<leader>ni` - Open index file
- `<leader>nr` - Return to previous location
- `<leader>nt` - Table of contents

### Mode-specific Commands (`<leader>m`)
- `<leader>mn` - New note
- `<leader>mt` - Cycle task state
- `<leader>md` - Insert date
- `<leader>me` - Export to file

### Task Management (`<leader>t`)
- `<leader>tc` - Cycle task state
- `<leader>tu` - Set task undone
- `<leader>tp` - Set task pending
- `<leader>td` - Set task done
- `<leader>tC` - Set task cancelled
- `<leader>tr` - Set task recurring
- `<leader>th` - Set task on hold

### List Management (`<leader>l`)
- `<leader>lt` - Toggle list type
- `<leader>li` - Invert list

### Journal Commands (`<leader>nj`)
- `<leader>njt` - Journal today
- `<leader>njy` - Journal yesterday
- `<leader>njm` - Journal tomorrow
- `<leader>njc` - Journal custom date

### Org-mode Style Bindings
- `<C-c><C-t>` - Cycle task state (org-mode style)
- `<Tab>` - Cycle task or follow link
- `<CR>` - Follow link
- `gf` - Follow link (vim style)

### Heading Management
- `>>` - Promote heading
- `<<` - Demote heading
- `M-<Right>` - Promote heading (Emacs style)
- `M-<Left>` - Demote heading (Emacs style)

### Code Blocks (`<leader>c`)
- `<leader>cm` - Magnify code block
- `<C-c><C-c>` - Magnify code block (org-mode style)

### Folding
- `<S-Tab>` - Toggle fold
- `zm` - Close all folds
- `zr` - Open all folds

### Telescope Integration (if available)
- `<leader>nf` - Find neorg files
- `<leader>nh` - Search headings
- `<leader>nl` - Find linkable items

## Getting Started

1. Open Neovim in your project directory
2. Press `<leader>nn` to open the notes workspace
3. Create a new file with `.norg` extension
4. Start writing notes using Neorg syntax

## Sample Note Structure

```norg
@document.meta
title: My Note
description: A sample note
authors: your-name
created: 2025-01-23
@end

* Main Heading

** Sub Heading

   - ( ) Undone task
   - (x) Completed task
   - (-) Pending task

*** Code Example

   @code lua
   print("Hello Neorg!")
   @end

** Links

   You can link to {* Main Heading}[other headings] or create
   {/ path/to/file}[file links].
```

## Customization

The configuration is located in `lua/plugins/neorg.lua`. You can:

- Modify workspace paths in the `core.dirman` config
- Adjust keybindings in the autocmd callback
- Add new workspaces or features as needed
- Customize icons in the `core.concealer` config

## Tips

1. Use `<leader>` followed by the category prefix for easy discovery
2. Which-key will show available keybinds after pressing `<leader>`
3. The configuration respects existing vim keybinds to avoid conflicts
4. All keybinds are buffer-local to `.norg` files only

## Troubleshooting

If you encounter issues:

1. Run `:checkhealth neorg` to see any conflicts
2. Ensure all workspace directories exist
3. Check that neorg is properly loaded with `:Lazy`
4. Verify the configuration with `:NixCats` to see available categories