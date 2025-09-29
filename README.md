# Nano's Neovim Configuration

A not so finished Neovim configuration built with [nixCats](https://github.com/BirdeeHub/nixCats-nvim) and based on kickstart.nvim

## Features

### 🎯 **Core Features**
- **Space-based keybinds** - Intuitive leader key mappings organized by category
- **LSP integration** - Full language server support with diagnostics and code actions
- **Treesitter** - Enhanced syntax highlighting and code understanding
- **Telescope** - Fuzzy finding for files, buffers, and commands
- **Git integration** - Neogit for comprehensive Git workflow
### 📋 **Key Categories**
- **Files** (`SPC f`) - Save, format, tree, oil browser
- **Buffers** (`SPC b`) - Buffer management and navigation
- **Windows** (`SPC w`) - Window operations and layouts
- **Code** (`SPC c`) - LSP operations, compilation, formatting
- **Errors** (`SPC e`) - Error navigation and fixing
- **Jump** (`SPC j`) - Advanced navigation with Flash and treesitter
- **Git** (`SPC g`) - Git operations with Neogit
- **Open** (`SPC o`) - Open terminal, files, undo tree
- **Toggle** (`SPC t`) - Toggle various features and UI elements

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

## Key Highlights

### Most Used Keybinds
- **`SPC SPC`** - Command palette (most important!)
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

## Credits

- Built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Powered by [nixCats](https://github.com/BirdeeHub/nixCats-nvim)
- Plugin ecosystem from the amazing Neovim community
