# Nix Architecture

This document explains how Nix is used in this Neovim configuration via the
[nixCats](https://github.com/BirdeeHub/nixCats-nvim) framework. It covers the
flake structure, category system, overlay pipeline, custom plugin packaging,
and the Lua-Nix bridge that lets Lua code query Nix-defined values at runtime.

---

## Table of Contents

1. [Overview](#overview)
2. [Flake Structure](#flake-structure)
3. [Category System](#category-system)
4. [Package Definitions](#package-definitions)
5. [Overlay System](#overlay-system)
6. [Custom Plugin Packaging](#custom-plugin-packaging)
7. [Lua-Nix Bridge](#lua-nix-bridge)
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
2. Wraps the `nvim` binary using `makeWrapper` to prepend tools to `PATH`
   and set environment variables.
3. Injects the `nixCats` Lua plugin into the runtime path so your config
   can query Nix-defined values.
4. Optionally bundles your Lua config (`wrapRc = true`) or points at an
   external config directory.

---

## Flake Structure

### Inputs

The flake declares three inputs:

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";
  nixCats.url = "github:BirdeeHub/nixCats-nvim";
};
```

| Input | Purpose |
|---|---|
| `nixpkgs` (unstable) | Primary package set for plugins, LSPs, and tools. Provides the latest versions. |
| `nixpkgs-2505` (25.05) | Stable channel used selectively. Currently used to pull treesitter parsers (like `norg`) that may be broken on unstable. |
| `nixCats` | The framework itself. Provides the builder, utilities, module generators, and the `nixCats` Lua plugin. |

Flake inputs named with the prefix `plugins-` (e.g. `plugins-someplugin`)
are automatically picked up by `utils.standardPluginOverlay` and made
available as `pkgs.neovimPlugins.<name>`. This project does not currently use
any `plugins-` inputs but the mechanism is available.

### Outputs structure

```
outputs
  +-- per-system (via forEachSystem)
  |     +-- packages.default     (the built Neovim)
  |     +-- packages.nvim        (same, by name)
  |     +-- devShells.default    (shell with Neovim available)
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
  where `allowUnfreePredicate` lives (currently allowing `copilot.vim` and
  `copilot-language-server`).
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

The `categoryDefinitions` function receives `{ pkgs, settings, categories, ... }`
and returns an attribute set with the following keys:

#### `lspsAndRuntimeDeps`

Programs added to `PATH` inside the Neovim wrapper. This is where LSPs,
formatters, linters, and CLI tools go.

```nix
lspsAndRuntimeDeps = with pkgs; {
  general = [
    universal-ctags ripgrep fd
    stdenv.cc.cc nix-doc
    lua-language-server nixd nixfmt stylua
    python3Packages.python-lsp-server
    rust-analyzer clang-tools
    haskell-language-server gleam
  ];
  kickstart-debug = [ delve ];
  kickstart-lint  = [ markdownlint-cli ];
};
```

When the `general` category is enabled in a package definition, all of
those tools become available to Neovim at runtime without any system-wide
installation.

#### `startupPlugins`

Vim plugins loaded at startup (placed in `pack/*/start/`). This is the
primary plugin list since this config uses lazy.nvim for loading control.

```nix
startupPlugins = with pkgs.vimPlugins; {
  general = [
    vim-sleuth lazy-nvim snacks-nvim nvim-lspconfig
    nvim-treesitter.withAllGrammars
    # ... 60+ plugins
  ];
  kickstart-debug    = [ nvim-dap nvim-dap-ui nvim-dap-go nvim-nio ];
  kickstart-lint     = [ nvim-lint ];
  kickstart-autopairs = [ nvim-autopairs ];
  kickstart-neo-tree = [ neo-tree-nvim nui-nvim nvim-web-devicons plenary-nvim ];
  neorg = [ neorg lua-utils-nvim pathlib-nvim ];
};
```

Note: Although there is an `optionalPlugins` type (for `pack/*/opt/`
plugins loaded via `:packadd`), this config puts everything in
`startupPlugins` because lazy.nvim handles the actual lazy-loading. The
distinction between `startupPlugins` and `optionalPlugins` is irrelevant
when lazy.nvim manages loading.

#### `sharedLibraries`

Native shared libraries added to `LD_LIBRARY_PATH`. Currently empty but
available for plugins that need `.so` files at runtime (e.g. `libgit2`).

```nix
sharedLibraries = {
  general = with pkgs; [
    # libgit2
  ];
};
```

#### `environmentVariables`

Environment variables injected into the Neovim wrapper.

```nix
environmentVariables = {
  test = {
    CATTESTVAR = "It worked!";
  };
};
```

#### `extraWrapperArgs`

Raw arguments passed to `makeWrapper`. Useful for `--set`, `--prefix`, or
other wrapper flags.

```nix
extraWrapperArgs = {
  test = [
    ''--set CATTESTVAR2 "It worked again!"''
  ];
};
```

#### `python3.libraries` and `extraLuaPackages`

For Python and Lua package dependencies, respectively. These populate
`python3_host_prog` and `$LUA_PATH`/`$LUA_CPATH`.

### Feature Flag Categories

The category names serve as feature flags. The current categories are:

| Category | What it controls |
|---|---|
| `general` | Core tools, LSPs, and the main plugin set |
| `kickstart-debug` | DAP (Debug Adapter Protocol) plugins and `delve` |
| `kickstart-lint` | `nvim-lint` and `markdownlint-cli` |
| `kickstart-autopairs` | `nvim-autopairs` |
| `kickstart-neo-tree` | Neo-tree file explorer and its dependencies |
| `kickstart-indent_line` | Indent line plugins (empty list, used as a flag) |
| `kickstart-gitsigns` | Pure Lua-side flag (no extra Nix packages needed) |
| `neorg` | Neorg note-taking plugins |
| `test` | Test environment variables and wrapper args |
| `gitPlugins` / `customPlugins` | Flags for Lua-side logic |

Categories with empty lists (like `kickstart-indent_line`) still serve a
purpose: their boolean value is passed to Lua via the `nixCats` plugin,
where it can gate configuration blocks.

---

## Package Definitions

Package definitions select which categories to enable and configure
package-level settings. Each entry in `packageDefinitions` is a function
receiving `{ pkgs, name, ... }` and returning `{ settings, categories }`.

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
  gitPlugins = true;
  customPlugins = true;
  test = true;
  kickstart-autopairs = true;
  kickstart-neo-tree = true;
  kickstart-debug = true;
  kickstart-lint = true;
  kickstart-indent_line = true;
  kickstart-gitsigns = true;

  neorg = {
    defaultWorkspace = "notes";
    workspaces = {
      notes = "~/notes/neorg";
    };
  };

  have_nerd_font = false;

  example = {
    youCan = "add more than just booleans";
    toThisSet = [ "accessible via nixCats('path.to.value')" ];
  };
};
```

Categories are not limited to booleans. Any Nix value assigned to a
category name is passed through to Lua. The `neorg` category above is a
table with workspace paths that Lua code reads at runtime via
`nixCats('neorg.defaultWorkspace')`.

### Multiple Packages

You can define multiple packages in `packageDefinitions` with different
category selections. For example, you could add a `nvim-minimal` package
with only `general = true` and no debug/lint/neorg categories. The
`defaultPackageName` variable controls which one is the default output.

---

## Overlay System

The `dependencyOverlays` list contains three overlays applied to nixpkgs
before building:

### 1. Standard Plugin Overlay

```nix
(utils.standardPluginOverlay inputs)
```

Scans flake inputs for names matching `plugins-<name>` and adds them to
`pkgs.neovimPlugins.<name>`. This is nixCats' mechanism for pulling in
plugins not yet in nixpkgs. Currently unused in this config but available
for future use.

### 2. Stable Treesitter Parser Overlay

```nix
(final: prev:
  let
    stablePkgs = import inputs.nixpkgs-2505 { ... };
    stableParsers = stablePkgs.vimPlugins.nvim-treesitter-parsers or {};
    prevParsers = prev.vimPlugins.nvim-treesitter-parsers or {};
    mergedParsers = prevParsers // (builtins.listToAttrs (
      builtins.filter (attr: attr != null) [
        (if stableParsers ? norg then {
          name = "norg"; value = stableParsers.norg;
        } else null)
      ]
    ));
  in {
    vimPlugins = prev.vimPlugins // {
      nvim-treesitter-parsers = mergedParsers;
    };
  }
)
```

This overlay merges specific treesitter parsers from the stable nixpkgs
channel (25.05) into the unstable parser set. The `norg` parser is
sometimes broken on unstable, so it is pulled from stable as a fallback.
The pattern is extensible -- add more entries to the list to pin other
parsers to stable.

### 3. Custom Plugin Overlay

```nix
(final: prev: {
  vimPlugins = prev.vimPlugins // {
    myeyeshurt = prev.callPackage ./packages/myEyesHurt {};
    neominimap = prev.callPackage ./packages/neoMiniMap {};
    indentRainbowline = prev.callPackage ./packages/indentRainbowline {
      indent-blankline-nvim = prev.vimPlugins.indent-blankline-nvim;
    };
  };
})
```

Adds locally-packaged plugins (from the `packages/` directory) to
`pkgs.vimPlugins` so they can be referenced by name in `startupPlugins`
just like any nixpkgs plugin. See [Custom Plugin Packaging](#custom-plugin-packaging)
below.

---

## Custom Plugin Packaging

Plugins not available in nixpkgs are packaged locally in the `packages/`
directory. Each package is a Nix file that uses `vimUtils.buildVimPlugin`
to fetch source from GitHub and produce a Vim plugin derivation.

### Basic plugin: `packages/myEyesHurt/default.nix`

```nix
{ lib, vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "myeyeshurt";
  version = "2024-05-04";
  src = fetchFromGitHub {
    owner = "wildfunctions";
    repo = "myeyeshurt";
    rev = "02922e14aeaba6d305ac93b70668774963554938";
    sha256 = "0sw87f0ji1840qid1b42fin5a05p3nk9d2fx3wsnv8zlnr0xm4px";
  };
  meta = with lib; {
    description = "Neovim wellness plugin that animates snowflakes to prompt screen breaks";
    homepage = "https://github.com/wildfunctions/myeyeshurt";
    license = licenses.mit;
  };
}
```

### Plugin with dependencies: `packages/indentRainbowline/default.nix`

```nix
{ lib, vimUtils, fetchFromGitHub, indent-blankline-nvim }:

vimUtils.buildVimPlugin {
  pname = "indent-rainbowline-nvim";
  version = "2024-10-08";
  src = fetchFromGitHub {
    owner = "TheGLander";
    repo = "indent-rainbowline.nvim";
    rev = "572e8157de85d7af3f0085b5c74c059518900649";
    sha256 = "11y1g7njfy9pd2gk9vv6n8921k7ynb4n4hpl9xb9cqwgpjsws9bm";
  };
  meta = with lib; { /* ... */ };
  dependencies = [ indent-blankline-nvim ];
}
```

The `dependencies` field tells Nix to include `indent-blankline-nvim`
alongside this plugin. The dependency is passed in from the overlay via
`callPackage`.

### How to add a new custom plugin

1. Create `packages/<name>/default.nix` following the pattern above.
2. Add it to the custom plugin overlay in `flake.nix`:
   ```nix
   myNewPlugin = prev.callPackage ./packages/<name> {};
   ```
3. Reference it by name in a `startupPlugins` category:
   ```nix
   startupPlugins = {
     general = [ /* ... */ pkgs.vimPlugins.myNewPlugin ];
   };
   ```

---

## Lua-Nix Bridge

The `lua/nixCatsUtils/` directory provides utilities that let Lua code
work both with and without Nix. When Neovim is loaded via nixCats, the
`nixCats` Lua plugin is injected into the runtime path automatically.

### `nixCatsUtils/init.lua`

#### `isNixCats`

```lua
local isNixCats = require('nixCatsUtils').isNixCats
-- true when loaded via nixCats, false otherwise
```

Detects whether the current Neovim instance was built by nixCats by
checking for a special runtime path entry.

#### `setup()`

```lua
require('nixCatsUtils').setup {
  non_nix_value = true,
}
```

When **not** running under nixCats, this creates a mock `nixCats` plugin
so that `nixCats('some.category')` calls do not error out. The
`non_nix_value` sets the default return value for all category queries
in non-Nix mode (defaults to `true`).

When running under nixCats, `setup()` does nothing -- the real plugin is
already available.

#### `enableForCategory(category, default)`

```lua
if require('nixCatsUtils').enableForCategory('kickstart-autopairs') then
  -- configure autopairs
end
```

Returns a boolean indicating whether a category is enabled. Under Nix, it
queries `nixCats(category)`. Without Nix, it returns the `default` argument
(or the `non_nix_value` from `setup()` if no default is given).

#### `getCatOrDefault(category, default)`

```lua
local workspace = require('nixCatsUtils').getCatOrDefault(
  'neorg.defaultWorkspace', 'notes'
)
```

Like `enableForCategory` but returns the raw value instead of coercing to
boolean. Useful for categories that hold strings, tables, or other
non-boolean data.

#### `lazyAdd(non_nix_value, nix_value)`

```lua
build = require('nixCatsUtils').lazyAdd('make'),
-- Under Nix: returns nil (nix already built it)
-- Without Nix: returns 'make' (needs to build at runtime)

enabled = require('nixCatsUtils').lazyAdd(true, false),
-- Under Nix: returns false (e.g., disable Mason)
-- Without Nix: returns true (enable Mason)
```

Returns the first argument when not using Nix, or the second argument
(default `nil`) when using Nix. This is the primary tool for writing
dual-mode plugin specs that work both with and without Nix. Common uses:

- **Disable build steps under Nix** (Nix already compiled them):
  `build = require('nixCatsUtils').lazyAdd(':TSUpdate')`
- **Disable Mason under Nix** (Nix provides LSPs):
  `enabled = require('nixCatsUtils').lazyAdd(true, false)`
- **Skip runtime conditions under Nix**:
  `cond = require('nixCatsUtils').lazyAdd(function() return vim.fn.executable('make') == 1 end)`

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

1. **Finds lazy.nvim**: Accepts the Nix-provided path to lazy.nvim as the
   first argument. Falls back to git-cloning if `nil` (non-Nix mode).

2. **Configures `dev.path`**: Tells lazy.nvim to find plugins in the
   nixCats package directory (`pack/myNeovimPackages/start/` and `opt/`)
   instead of downloading them.

3. **Sets `dev.patterns = { "" }`**: Makes lazy.nvim treat *all* plugins as
   "dev" plugins (i.e., use the local Nix-provided copies).

4. **Disables runtime features under Nix**:
   - `performance.rtp.reset = false` -- preserves the Nix-configured
     runtime path.
   - `install.missing = false` -- prevents lazy from downloading plugins
     that Nix already provides.
   - `checker.enabled = false` -- disables update checking.

5. **Rebuilds the runtime path**: Sets a minimal `rtp` that includes the
   config dir, nixCats path, treesitter grammar path, and standard Neovim
   directories.

### The `nixCats()` global function

After `nixCatsUtils.setup()` runs (or when loaded via Nix), a global
`nixCats` function is available:

```lua
-- Query a boolean category
if nixCats('general') then ... end

-- Query a nested value
local workspace = nixCats('neorg.defaultWorkspace')  --> "notes"

-- Access settings
local configDir = nixCats.settings.nixCats_config_location

-- Access the list of all installed plugins
local allPlugins = nixCats.pawsible.allPlugins
```

The `nixCats.pawsible` table contains information about what Nix made
available, including `allPlugins.start` and `allPlugins.opt`.

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

Drops you into a shell with the Neovim package available. Useful for
testing or CI environments.

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

3. **Configured in Lua**: `nvim-lspconfig` is told to use `vim.lsp.config`
   and `vim.lsp.enable` directly (no Mason):
   ```lua
   if require('nixCatsUtils').isNixCats then
     for server_name, cfg in pairs(servers) do
       vim.lsp.config(server_name, cfg)
       vim.lsp.enable(server_name)
     end
   else
     -- Non-Nix: use Mason to install and configure
     require('mason').setup()
     require('mason-lspconfig').setup { ... }
   end
   ```

4. **Mason is disabled under Nix**: `lazyAdd(true, false)` on Mason's
   `enabled` field ensures it never runs when Nix provides the tools.

### Treesitter Grammars

1. **All grammars included**: `nvim-treesitter.withAllGrammars` in
   `startupPlugins.general` bundles every available grammar.

2. **Stable parser fallback**: The treesitter overlay merges specific
   parsers from nixpkgs-25.05 (currently `norg`) to avoid breakage on
   unstable.

3. **Auto-install disabled under Nix**:
   ```lua
   auto_install = require('nixCatsUtils').lazyAdd(true, false),
   ```

4. **`:TSUpdate` skipped under Nix**:
   ```lua
   build = require('nixCatsUtils').lazyAdd(':TSUpdate'),
   ```

### Plugins

1. **Nixpkgs plugins**: Referenced directly from `pkgs.vimPlugins.*` in
   category lists.

2. **Custom plugins**: Packaged in `packages/`, added to
   `pkgs.vimPlugins` via the custom plugin overlay, then referenced like
   any other plugin.

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
  +-- categoryDefinitions (what packages exist per category)
  +-- packageDefinitions  (which categories are enabled)
  |
  v
nixCats builder
  |
  +-- Resolves overlays (standard plugin, treesitter, custom)
  +-- Collects enabled packages from enabled categories
  +-- Wraps nvim binary (PATH, LD_LIBRARY_PATH, env vars)
  +-- Bundles Lua config (wrapRc = true)
  +-- Injects nixCats Lua plugin
  |
  v
Neovim starts
  |
  +-- init.lua calls nixCatsUtils.setup()
  +-- nixCats('category') queries drive conditional config
  +-- lazyCat.setup() integrates lazy.nvim with Nix-provided plugins
  +-- LSPs found on PATH, no Mason needed
  +-- Treesitter grammars pre-installed, no :TSUpdate needed
```
