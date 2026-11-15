# Nix Architecture

This document explains how Nix is used in this Neovim configuration via the
[nixCats](https://github.com/BirdeeHub/nixCats-nvim) framework. It covers the
flake structure, category system, how plugins outside nixpkgs are pulled in,
the Lua-Nix bridge that lets Lua code query Nix-defined values at runtime,
and the checks that CI runs.

---

## Table of Contents

1. [Overview](#overview)
2. [Flake Structure](#flake-structure)
3. [Category System](#category-system)
4. [Package Definitions](#package-definitions)
5. [Plugins Outside nixpkgs](#plugins-outside-nixpkgs)
6. [Lua-Nix Bridge](#lua-nix-bridge)
7. [Checks and Formatting](#checks-and-formatting)
8. [Installation Methods](#installation-methods)
9. [Dependency Flow](#dependency-flow)

---

## Overview

### What is nixCats?

nixCats is a Nix framework for building reproducible, fully self-contained
Neovim packages. Instead of relying on runtime plugin managers to download
plugins, LSPs, and tools, nixCats uses Nix to:

- Pin every dependency (plugins, LSPs, formatters, CLI tools) to exact
  versions via the Nix store.
- Wrap the Neovim binary so that all runtime dependencies are on `PATH`,
  `LD_LIBRARY_PATH`, and other environment variables automatically.
- Bundle the Lua configuration directory directly into the package (when
  `wrapRc = true`), producing a single self-contained derivation.
- Expose a **category system** that lets you toggle groups of dependencies
  on and off, producing different package variants from the same config.

This configuration is **Nix-only**: there is no Mason and no fallback path
where lazy.nvim downloads plugins. lazy.nvim is still used, but only to
decide *when* each Nix-provided plugin loads.

### Why nixCats over plain Nix?

Writing raw Nix expressions to wrap Neovim is verbose and error-prone. nixCats
provides:

- A **builder** that handles `makeWrapper`, plugin symlinking, and
  treesitter grammar management.
- A **category DSL** (simple attribute sets) for organizing dependencies.
- Automatic export of NixOS modules, Home Manager modules, overlays, and
  `devShell` outputs.
- A Lua plugin (`nixCats`) injected at build time that lets your Lua code
  query which categories and settings are active.

### How it wraps Neovim

The nixCats builder takes your Lua directory, list of plugins, runtime
dependencies, and settings, then produces a derivation that:

1. Creates a Neovim package directory with `start/` and `opt/` plugin
   subdirectories.
2. Wraps the `nvim` binary using `makeWrapper` to add tools to `PATH`
   and set environment variables.
3. Injects the `nixCats` Lua plugin into the runtime path so your config
   can query Nix-defined values.
4. Optionally bundles your Lua config (`wrapRc = true`) or points at an
   external config directory.

---

## Flake Structure

### Inputs

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  nixCats.url = "github:BirdeeHub/nixCats-nvim";

  plugins-neojjit            = { url = "github:JulianNymark/neojjit"; flake = false; };
  plugins-myeyeshurt         = { url = "github:wildfunctions/myeyeshurt"; flake = false; };
  plugins-neominimap         = { url = "github:Isrothy/neominimap.nvim"; flake = false; };
  plugins-indent-rainbowline = { url = "github:TheGLander/indent-rainbowline.nvim"; flake = false; };
};
```

| Input | Purpose |
|---|---|
| `nixpkgs` (unstable) | Primary package set for plugins, LSPs, and tools. |
| `nixCats` | The framework itself. Provides the builder, utilities, module generators, and the `nixCats` Lua plugin. |
| `plugins-*` | Source trees of plugins that are not in nixpkgs. See [Plugins Outside nixpkgs](#plugins-outside-nixpkgs). |

Everything is pinned by `flake.lock`, so `nix flake update` is the single
way to bump nixpkgs, nixCats, and the extra plugins.

### Outputs structure

```
outputs
  +-- per-system (x86_64-linux, aarch64-linux, aarch64-darwin)
  |     +-- packages.default     (the built Neovim)
  |     +-- packages.nvim        (same, by name)
  |     +-- devShells.default    (shell with Neovim, stylua and nixfmt)
  |     +-- formatter            (nixfmt, for `nix fmt`)
  |     +-- checks               (startup smoke test, stylua, nixfmt)
  |
  +-- cross-system
        +-- overlays             (for consuming from other flakes)
        +-- nixosModules.default (NixOS module)
        +-- homeModules.default  (Home Manager module)
        +-- templates            (nixCats starter templates)
```

### The Builder Pattern

The core of the outputs is the `nixCatsBuilder` call:

```nix
nixCatsBuilder = utils.baseBuilder luaPath {
  inherit nixpkgs system dependencyOverlays extra_pkg_config;
} categoryDefinitions packageDefinitions;
```

Arguments:

- **`luaPath`** -- Path to the Lua configuration directory (`./.` in this
  project, meaning the flake root).
- **`nixpkgs`**, **`system`**, **`dependencyOverlays`**,
  **`extra_pkg_config`** -- Standard Nix plumbing. `extra_pkg_config` is
  where `allowUnfreePredicate` lives; it allows exactly the unfree packages
  this config uses (`copilot.vim`, `copilot-language-server`,
  `eyeliner.nvim`, `nvim-dap-vscode-js`, `vscode-js-debug`).
- **`categoryDefinitions`** -- The mapping from category names to lists of
  packages (see next section).
- **`packageDefinitions`** -- Named package configs that select which
  categories to enable.

The builder returns a function: give it a package name (e.g. `"nvim"`) and
it produces the final wrapped derivation.

---

## Category System

Categories are the core abstraction for organizing dependencies. Each
category is a named list of packages within a dependency type. A category
is either **enabled** or **disabled** per package definition; when enabled,
all packages in that category's lists are included in the build.

### Dependency Types

The `categoryDefinitions` function receives `{ pkgs, ... }` and returns an
attribute set. This config uses two of the available keys:

#### `lspsAndRuntimeDeps`

Programs added to `PATH` inside the Neovim wrapper. This is where LSPs,
formatters, linters, debug adapters, and CLI tools go.

```nix
lspsAndRuntimeDeps = with pkgs; {
  general = [
    universal-ctags ripgrep fd nix-doc
    lua-language-server nixd nixfmt stylua
    ruff ty            # Python: linting/formatting and type checking
    rust-analyzer
    gleam
    jujutsu            # required by neojjit
  ];
  kickstart-debug = [ delve lldb ];
  kickstart-lint  = [ markdownlint-cli ];
};
```

When the `general` category is enabled in a package definition, all of
those tools become available to Neovim at runtime without any system-wide
installation.

`git` is not in this list: it is expected to come from your own `PATH`.

#### `startupPlugins`

Vim plugins placed in `pack/*/start/`. This is the only plugin list, since
lazy.nvim controls when each plugin actually loads.

```nix
startupPlugins = with pkgs.vimPlugins; {
  general = [
    vim-sleuth lazy-nvim snacks-nvim nvim-lspconfig
    nvim-treesitter.withAllGrammars
    # ... 70+ plugins
    pkgs.neovimPlugins.neojjit
    pkgs.neovimPlugins.myeyeshurt
    pkgs.neovimPlugins.neominimap
    pkgs.neovimPlugins.indent-rainbowline
  ];
  kickstart-debug = [
    nvim-dap nvim-dap-ui nvim-dap-go nvim-nio
    nvim-dap-python nvim-dap-vscode-js one-small-step-for-vimkind
  ];
  kickstart-lint     = [ nvim-lint ];
  kickstart-neo-tree = [ neo-tree-nvim nui-nvim nvim-web-devicons plenary-nvim ];
  obsidian = [ obsidian-nvim ];
  orgmode  = [ orgmode ];
};
```

#### Other dependency types

nixCats also supports `optionalPlugins` (`pack/*/opt/`), `sharedLibraries`
(`LD_LIBRARY_PATH`), `environmentVariables`, `extraWrapperArgs`,
`python3.libraries`, and `extraLuaPackages`. None of them are needed here,
so they are not defined; see `:help nixCats.flake.outputs.categories` if
you want to add one.

### Feature Flag Categories

The category names serve as feature flags. The current categories are:

| Category | What it controls |
|---|---|
| `general` | Core tools, LSPs, and the main plugin set |
| `kickstart-debug` | DAP (Debug Adapter Protocol) plugins, `delve`, and `lldb` |
| `kickstart-lint` | `nvim-lint` and `markdownlint-cli` |
| `kickstart-neo-tree` | Neo-tree file explorer and its dependencies |
| `kickstart-autopairs` | Lua-side flag only: enables `mini.pairs` |
| `kickstart-indent_line` | Lua-side flag only: enables Snacks scope/indent guides |
| `kickstart-gitsigns` | Lua-side flag only: enables gitsigns |
| `obsidian` | Obsidian note-taking plugin |
| `orgmode` | Orgmode note-taking plugin |

The "Lua-side flag only" categories need no extra Nix packages, so they
have no entry in `categoryDefinitions`. Their value is still passed to Lua
via the `nixCats` plugin, where it gates configuration blocks.

---

## Package Definitions

Package definitions select which categories to enable and configure
package-level settings. Each entry in `packageDefinitions` is a function
receiving `{ pkgs, ... }` and returning `{ settings, categories }`.

### Settings

```nix
settings = {
  suffix-path = true;      # Suffix Nix paths to existing PATH (not prefix)
  suffix-LD = true;        # Same for LD_LIBRARY_PATH
  wrapRc = true;           # Bundle the Lua config into the derivation
  aliases = [ "vim" ];     # Create a "vim" symlink to this package
  hosts.python3.enable = true;  # Enable Python 3 provider
  hosts.node.enable = true;     # Enable Node.js provider
};
```

Key settings explained:

- **`wrapRc = true`**: The Lua config at `luaPath` is copied into the Nix
  store and loaded from there. This makes the package fully self-contained
  and reproducible. Set to `false` during development to load from your
  working directory instead.
- **`suffix-path = true`**: Nix-provided tools are appended to `PATH`
  rather than prepended. This lets system tools take priority when both
  exist.
- **`aliases`**: Additional binary names. Here, `vim` is an alias for the
  `nvim` package.
- **`hosts.*`**: Enable language providers (Python, Node) for plugins that
  need them (e.g. `nvim-dbee`).

### Category Toggles

```nix
categories = {
  general = true;

  kickstart-neo-tree = true;
  kickstart-debug = {
    enabled = true;
    debugpy_python = "${pkgs.python3.withPackages (ps: [ ps.debugpy ])}/bin/python3";
    js_debug_cmd = "${pkgs.vscode-js-debug}/bin/js-debug";
  };
  kickstart-lint = true;

  kickstart-autopairs = true;
  kickstart-indent_line = true;
  kickstart-gitsigns = true;

  obsidian = {
    enabled = true;
    defaultVault = "personal";
    vaults = {
      personal = "~/notes/obsidian";
    };
  };

  orgmode = {
    enabled = true;
    orgDir = "~/notes/org";
  };

  have_nerd_font = true;
};
```

Categories are not limited to booleans. Any Nix value assigned to a
category name is passed through to Lua. The `obsidian` category above is a
table with vault paths that Lua code reads at runtime via
`nixCats('obsidian.defaultVault')`, and `kickstart-debug` carries the store
paths of the Python and JavaScript debug adapters.

`have_nerd_font` controls icon-related options across the config
(statusline, bufferline, the lazy.nvim UI). Set it to `false` if your
terminal font has no Nerd Font glyphs.

### Multiple Packages

You can define multiple packages in `packageDefinitions` with different
category selections. For example, you could add a `nvim-minimal` package
with only `general = true` and no debug/lint categories. The
`defaultPackageName` variable controls which one is the default output.

---

## Plugins Outside nixpkgs

A few plugins are not packaged in nixpkgs. They are declared as flake
inputs named `plugins-<name>` with `flake = false`, and a single overlay
turns every such input into a plugin:

```nix
dependencyOverlays = [
  (utils.standardPluginOverlay inputs)
];
```

`standardPluginOverlay` scans the flake inputs for the `plugins-` prefix,
builds each one with `vimUtils.buildVimPlugin`, and exposes it as
`pkgs.neovimPlugins.<name>`. Their revisions live in `flake.lock`
alongside everything else, so there are no hand-written hashes to maintain.

### Plugin names and lazy.nvim

`<name>` also becomes the plugin's directory name, and lazy.nvim looks
plugins up by the name it derives from the spec (`'owner/repo'` gives
`repo`). When the two differ, tell lazy the directory name:

```lua
{
  'Isrothy/neominimap.nvim',
  -- built from the `plugins-neominimap` flake input
  name = 'neominimap',
}
```

Input names cannot contain dots (Nix rejects them as flake IDs in places
like `--inputs-from`), which is why `neominimap.nvim` and
`indent-rainbowline.nvim` are named without their `.nvim` suffix.

### How to add a plugin that is not in nixpkgs

1. Add an input to `flake.nix`:
   ```nix
   plugins-myplugin = { url = "github:owner/myplugin.nvim"; flake = false; };
   ```
2. Reference it in a `startupPlugins` category:
   ```nix
   general = [ /* ... */ pkgs.neovimPlugins.myplugin ];
   ```
3. Add a lazy spec under `lua/plugins/`, with `name = 'myplugin'` if the
   repository name differs.
4. Run `nix flake lock` to pin it.

---

## Lua-Nix Bridge

When Neovim is built by nixCats, a `nixCats` Lua plugin is injected into
the runtime path and a global `nixCats` function is defined before
`init.lua` runs.

### The `nixCats()` global function

```lua
-- Query a boolean category
if nixCats('general') then ... end

-- Query a nested value
local vault = nixCats('obsidian.defaultVault')  --> "personal"

-- Access settings
local configDir = nixCats.settings.nixCats_config_location

-- Access the list of all installed plugins
local allPlugins = nixCats.pawsible.allPlugins
```

The `nixCats.pawsible` table contains information about what Nix made
available, including `allPlugins.start` and `allPlugins.opt`.

### `nixCatsUtils/init.lua`

Two small helpers for plugin specs:

#### `enableForCategory(category)`

```lua
enabled = require('nixCatsUtils').enableForCategory 'kickstart-lint',
```

Returns a strict boolean. Use it for lazy.nvim's `enabled` field: a bare
`nixCats('...')` returns `nil` for an unset category, and lazy treats
`enabled = nil` as *enabled*.

#### `getCatOrDefault(category, default)`

```lua
local vault = require('nixCatsUtils').getCatOrDefault(
  { 'obsidian', 'defaultVault' }, 'personal'
)
```

Returns the raw value Nix passed for a category, or `default` when it is
unset. Useful for categories that hold strings, tables, or other
non-boolean data.

### `nixCatsUtils/lazyCat.lua` -- lazy.nvim Integration

```lua
require('nixCatsUtils.lazyCat').setup(
  nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' },
  { /* plugin specs */ },
  lazyOptions
)
```

This wrapper around `require('lazy').setup()` handles the integration
between nixCats-managed plugins and lazy.nvim:

1. **Takes the Nix-provided lazy.nvim path** as its first argument.

2. **Configures `dev.path`**: Tells lazy.nvim to find plugins in the
   nixCats package directory (`pack/myNeovimPackages/start/` and `opt/`)
   instead of downloading them. Plugins are matched **by name**, which is
   why a spec only needs a `name =` override when the directory name
   differs from the repository name.

3. **Sets `dev.patterns = { "" }`**: Makes lazy.nvim treat *all* plugins as
   "dev" plugins (i.e., use the local Nix-provided copies).

4. **Disables lazy.nvim's package-manager features**:
   - `performance.rtp.reset = false` -- preserves the Nix-configured
     runtime path.
   - `install.missing = false` -- lazy never downloads anything.
   - `checker.enabled = false` -- disables update checking.

5. **Rebuilds the runtime path**: Sets a minimal `rtp` that includes the
   config dir, nixCats path, treesitter grammar path, and standard Neovim
   directories.

---

## Checks and Formatting

`nix flake check` evaluates every output and builds three checks:

| Check | What it does |
|---|---|
| `checks.<system>.startup` | Builds the package, starts it headless, loads every plugin (`checks/startup.lua`), and fails on any error raised during startup or by a plugin's config. |
| `checks.<system>.stylua` | `stylua --check .` with the stylua pinned by `flake.lock`. |
| `checks.<system>.nixfmt` | `nixfmt --check flake.nix`. |

CI (`.github/workflows/check.yml`) runs exactly this command, so a local
`nix flake check` reproduces it. The startup check is what catches a
`nix flake update` that pulls in a plugin with a breaking change.

To format before committing:

```bash
nix fmt                       # flake.nix
nix develop -c stylua .       # Lua
```

---

## Installation Methods

### `nix run` -- Try without installing

```bash
nix run github:rft/nixcat-nvim
```

Builds and runs the default package in a temporary environment. Nothing is
installed to the system profile.

### `nix profile install` -- Imperative install

```bash
nix profile install github:rft/nixcat-nvim
```

Installs the package into your Nix profile. Updates require
`nix profile upgrade`.

### As a flake input -- Declarative package

```nix
# flake.nix
inputs.nano-nvim.url = "github:rft/nixcat-nvim";

# In NixOS configuration or Home Manager
environment.systemPackages = [ inputs.nano-nvim.packages.${system}.default ];
# or
home.packages = [ inputs.nano-nvim.packages.${system}.default ];
```

### NixOS Module

The flake exports a NixOS module that allows reconfiguration from
`configuration.nix`:

```nix
# flake.nix of your system config
inputs.nano-nvim.url = "github:rft/nixcat-nvim";

# configuration.nix
{ inputs, ... }: {
  imports = [ inputs.nano-nvim.nixosModules.default ];
  # Override categories, settings, etc. via the module options
}
```

### Home Manager Module

Same pattern, using the Home Manager module:

```nix
{ inputs, ... }: {
  imports = [ inputs.nano-nvim.homeModules.default ];
}
```

Both modules re-export all the same `categoryDefinitions` and
`packageDefinitions`, allowing downstream consumers to override or extend
the configuration without forking the flake.

### Dev Shell

```bash
nix develop github:rft/nixcat-nvim
```

Drops you into a shell with the Neovim package, `stylua`, and `nixfmt`
available.

---

## Dependency Flow

This section traces how a dependency moves from a Nix declaration to being
available at runtime in Neovim.

### LSP Servers

1. **Declared in Nix**: Added to `lspsAndRuntimeDeps.general` in
   `categoryDefinitions`:
   ```nix
   lspsAndRuntimeDeps = {
     general = [ pkgs.lua-language-server pkgs.nixd pkgs.rust-analyzer /* ... */ ];
   };
   ```

2. **Wrapped onto PATH**: The nixCats builder uses `makeWrapper` to add
   these to the Neovim binary's `PATH`.

3. **Configured in Lua**: `lua/plugins/lsp/lsp.lua` enables each server
   with the built-in `vim.lsp.config` / `vim.lsp.enable`:
   ```lua
   for server_name, cfg in pairs(servers) do
     vim.lsp.config(server_name, cfg)
     vim.lsp.enable(server_name)
   end
   ```

Adding a server is therefore two edits: the package in `flake.nix` and an
entry in the `servers` table.

### Treesitter Grammars

`nvim-treesitter.withAllGrammars` in `startupPlugins.general` bundles
every available grammar, so nothing is installed or updated at runtime.
`lua/plugins/editing/treesitter.lua` only has to start highlighting per
buffer.

### Plugins

1. **Nixpkgs plugins**: Referenced directly from `pkgs.vimPlugins.*` in
   category lists.

2. **Plugins outside nixpkgs**: Declared as `plugins-*` flake inputs and
   referenced from `pkgs.neovimPlugins.*`.

3. **lazy.nvim integration**: The `lazyCat.setup` wrapper configures
   lazy.nvim to find plugins in the Nix package directory instead of
   downloading them. The `dev.patterns = { "" }` setting tells lazy that
   every plugin is a "dev" plugin with a local path.

4. **Duplicate handling**: nixCats automatically deduplicates packages, so
   listing `plenary-nvim` in both `general` and `kickstart-neo-tree` is
   safe.

### CLI Tools (ripgrep, fd, formatters)

1. **Declared in Nix**: Added to `lspsAndRuntimeDeps`:
   ```nix
   general = [ pkgs.ripgrep pkgs.fd pkgs.stylua pkgs.nixfmt ];
   ```

2. **Available at runtime**: Wrapped onto `PATH`, available to both
   Neovim's built-in terminal (`:terminal`) and plugins like Snacks picker
   (which shells out to `rg` and `fd`).

### Runtime flow summary

```
flake.nix
  |
  +-- inputs              (nixpkgs, nixCats, plugins-* sources)
  +-- categoryDefinitions (what packages exist per category)
  +-- packageDefinitions  (which categories are enabled)
  |
  v
nixCats builder
  |
  +-- Applies the plugin overlay (plugins-* inputs -> pkgs.neovimPlugins)
  +-- Collects enabled packages from enabled categories
  +-- Wraps nvim binary (PATH, LD_LIBRARY_PATH, env vars)
  +-- Bundles Lua config (wrapRc = true)
  +-- Injects nixCats Lua plugin
  |
  v
Neovim starts
  |
  +-- nixCats('category') queries drive conditional config
  +-- lazyCat.setup() points lazy.nvim at the Nix-provided plugins
  +-- LSPs and tools found on PATH
  +-- Treesitter grammars pre-installed
```
