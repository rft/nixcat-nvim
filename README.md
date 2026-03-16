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

### Shell Alias
If you'd like to use `nvim` to launch this configuration via `nix run`:

```bash
# Add to your .bashrc, .zshrc, etc.
alias nvim='nix run github:rft/nixcat-nvim --'
```

The `--` ensures any arguments (filenames, flags) are passed through to Neovim.

## Documentation

- **[Plugin Reference](docs/plugins.md)** - Every plugin with purpose, keybinds, and config locations
- **[Keybind Reference](docs/keybinds.md)** - Complete keybind reference organized by category
- **[Nix Architecture](docs/nix-architecture.md)** - How nixCats, flakes, overlays, and the Lua-Nix bridge work

## Configuration Structure

```
├── flake.nix              # Nix configuration and package definitions
├── init.lua               # Main Neovim configuration entry point
├── lua/
│   ├── core/
│   │   ├── keymaps.lua    # Core keybind definitions
│   │   └── options.lua    # Neovim options and settings
│   └── plugins/
│       ├── general.lua    # Core plugins (Oil, undotree, etc.)
│       ├── ui/            # Visual/display plugins
│       ├── navigation/    # Search, jump, file tree
│       ├── editing/       # Text manipulation, autopairs, comments
│       ├── lsp/           # Language server configuration
│       ├── git/           # Git integration
│       ├── tools/         # Debug, lint, AI, terminal, sessions
│       └── neorg/         # Note-taking
```

## Credits

- Built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Powered by [nixCats](https://github.com/BirdeeHub/nixCats-nvim)
- Plugin ecosystem from the amazing Neovim community
