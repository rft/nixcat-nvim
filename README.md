# Nano's Neovim Configuration

A not so finished Neovim configuration built with [nixCats](https://github.com/BirdeeHub/nixCats-nvim) and based on kickstart.nvim

Mostly vibecoded so do not take what I have in here seriously. Reason for being so is that if my neovim config is not on parity with vscode, I will not use it, so it's a starting point.


## Quick Start

### Try Without Installing
You can try this configuration without committing to installing it:

```bash
nix run github:rft/nixcat-nvim
```

### Install

#### Nix Profile
Install imperatively with:

```bash
nix profile install github:rft/nixcat-nvim
```

#### Nix Flake Configuration
Add to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nano-nvim.url = "github:rft/nixcat-nvim";
  };
}
```

Then in your system or home-manager configuration:

```nix
# For system configuration
environment.systemPackages = [ inputs.nano-nvim.packages.${system}.default ];

# For home-manager
home.packages = [ inputs.nano-nvim.packages.${system}.default ];
```

#### NixOS Configuration
```nix
# In your configuration.nix
{ inputs, ... }: {
  environment.systemPackages = [
    inputs.nano-nvim.packages.${pkgs.system}.default
  ];
}
```

#### Home Manager
```nix
# In your home.nix
{ inputs, ... }: {
  home.packages = [
    inputs.nano-nvim.packages.${pkgs.system}.default
  ];
}
```

### **Key Categories**
- **Files** (`SPC f`) - Save, format, tree, oil browser
- **Buffers** (`SPC b`) - Buffer management and navigation
- **Windows** (`SPC w`) - Window operations and layouts
- **Code** (`SPC c`) - LSP operations, compilation, formatting
- **Errors** (`SPC e`) - Error navigation and fixing
- **Jump** (`SPC j`) - Advanced navigation with Flash and treesitter
- **Git** (`SPC g`) - Git operations with Neogit
- **Open** (`SPC o`) - Open terminal, files, undo tree
- **Toggle** (`SPC t`) - Toggle various features and UI elements

## Key Highlights

### Most Used Keybinds
- **`SPC SPC`** - Command palette 
- **`SPC f f`** - Format file/region
- **`SPC f t`** - File tree (Neo-tree)
- **`SPC f o`** - Oil file browser
- **`SPC j t`** - Jump to treesitter nodes
- **`SPC b b`** - Buffer search
- **`SPC e e`** - Show errors
- **`SPC g g`** - Git interface (Neogit)

## Configuration Structure

```
├── flake.nix              # Nix configuration and package definitions
├── init.lua               # Main Neovim configuration entry point
├── lua/
│   ├── core/
│   │   ├── keymaps.lua    # Core keybind definitions
│   │   └── options.lua    # Neovim options and settings
│   └── plugins/           # Plugin configurations
│       ├── general.lua    # Core plugins (Oil, undotree, etc.)
│       ├── buffers.lua    # Buffer management
│       ├── errors.lua     # Error handling (Trouble)
│       ├── git.lua        # Git integration (Neogit)
│       ├── jump.lua       # Navigation (Flash + treesitter)
│       ├── lsp.lua        # Language server configuration
│       ├── search.lua     # Search functionality
│       ├── terminal.lua   # Terminal integration
│       └── text-manipulation.lua  # Text editing features
```

## Dependencies

All dependencies are managed by Nix:
- **Language servers** - Lua, Nix, and development tools
- **CLI tools** - ripgrep, fd, git
- **Treesitter grammars** - All available grammars included
- **Fonts** - Nerd font support for icons

## Plugins

- akinsho/bufferline.nvim
- AndrewRadev/switch.vim
- andymass/vim-matchup
- B0o/dropbar.nvim
- b0o/incline.nvim
- camgraff/lensline.nvim
- danielfalk/smart-open.nvim
- dhruvasagar/vim-table-mode
- echasnovski/mini.nvim
- folke/flash.nvim
- folke/lazydev.nvim
- folke/persistence.nvim
- folke/sidekick.nvim
- folke/snacks.nvim
- folke/todo-comments.nvim
- folke/trouble.nvim
- folke/ts-comments.nvim
- folke/which-key.nvim
- gbprod/substitute.nvim
- github/copilot.vim
- HiPhish/rainbow-delimiters.nvim
- hrsh7th/cmp-nvim-lsp
- hrsh7th/cmp-path
- hrsh7th/nvim-cmp
- j-hui/fidget.nvim
- jay-babu/mason-nvim-dap.nvim
- jinh0/eyeliner.nvim
- JoosepAlviste/nvim-ts-context-commentstring
- jpalardy/vim-slime
- kevinhwang91/nvim-hlslens
- kkharji/sqlite.lua
- kndndrj/nvim-dbee
- L3MON4D3/LuaSnip
- leoluz/nvim-dap-go
- lewis6991/gitsigns.nvim
- lewis6991/satellite.nvim
- lukas-reineke/indent-blankline.nvim
- MagicDuck/grug-far.nvim
- matze/vim-move
- mbbill/undotree
- mfussenegger/nvim-dap
- mfussenegger/nvim-lint
- mg979/vim-visual-multi
- MunifTanjim/nui.nvim
- navarasu/onedark.nvim
- NeogitOrg/neogit
- neovim/nvim-lspconfig
- norcalli/nvim-colorizer.lua
- nvim-lua/plenary.nvim
- nvim-neo-tree/neo-tree.nvim
- nvim-neorg/lua-utils.nvim
- nvim-neorg/neorg
- nvim-neorg/neorg-telescope
- nvim-neorg/pathlib.nvim
- nvim-neotest/nvim-nio
- nvim-telescope/telescope-fzf-native.nvim
- nvim-telescope/telescope-ui-select.nvim
- nvim-telescope/telescope.nvim
- nvim-tree/nvim-web-devicons
- nvim-treesitter/nvim-treesitter
- nvim-treesitter/nvim-treesitter-context
- nvim-treesitter/nvim-treesitter-textobjects
- otavioschwanck/arrow.nvim
- OXY2DEV/markview.nvim
- rafamadriz/friendly-snippets
- ravibrock/spellwarn.nvim
- rcarriga/nvim-dap-ui
- RRethy/vim-illuminate
- saadparwaiz1/cmp_luasnip
- shortcuts/no-neck-pain.nvim
- sindrets/diffview.nvim
- stevearc/conform.nvim
- stevearc/oil.nvim
- TheGLander/indent-rainbowline.nvim
- tpope/vim-characterize
- tpope/vim-sleuth
- tzachar/highlight-undo.nvim
- WhoIsSethDaniel/mason-tool-installer.nvim
- williamboman/mason-lspconfig.nvim
- williamboman/mason.nvim
- windwp/nvim-ts-autotag

## Credits

- Built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Powered by [nixCats](https://github.com/BirdeeHub/nixCats-nvim)
- Plugin ecosystem from the amazing Neovim community
