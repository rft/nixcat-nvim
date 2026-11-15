# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
#
# Based on the nixCats kickstart template. Each section below is documented
# in :help nixCats.flake and in docs/nix-architecture.md.

{
  description = "Nano's Neovim configuration, built with nixCats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Plugins that are not in nixpkgs. Inputs named `plugins-<name>` are built
    # by utils.standardPluginOverlay and exposed as pkgs.neovimPlugins.<name>,
    # so `nix flake update` bumps them along with everything else. <name> is
    # also the plugin's directory name, which is what lazy.nvim looks it up by:
    # where it differs from the repo name, the lua spec sets `name = '<name>'`.
    plugins-neojjit = {
      url = "github:JulianNymark/neojjit";
      flake = false;
    };
    plugins-myeyeshurt = {
      url = "github:wildfunctions/myeyeshurt";
      flake = false;
    };
    plugins-neominimap = {
      url = "github:Isrothy/neominimap.nvim";
      flake = false;
    };
    plugins-indent-rainbowline = {
      url = "github:TheGLander/indent-rainbowline.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Passed to the nixpkgs that builds neovim: import nixpkgs { config = extra_pkg_config; }
      extra_pkg_config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "copilot.vim"
            "copilot-language-server"
            "eyeliner.nvim"
            "nvim-dap-vscode-js"
            "vscode-js-debug"
          ];
      };

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      # see :help nixCats.flake.outputs.categories
      categoryDefinitions =
        { pkgs, ... }:
        {
          # Available on PATH at run time, including in the neovim terminal.
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              universal-ctags
              ripgrep
              fd
              nix-doc
              lua-language-server
              nixd
              nixfmt
              stylua
              ruff # Astral: Python linter + formatter LSP (`ruff server`)
              ty # Astral: Python type checker LSP (`ty server`)
              rust-analyzer
              gleam
              jujutsu # required by neojjit
            ];
            kickstart-debug = [
              delve
              lldb # provides lldb-dap for Rust
            ];
            kickstart-lint = [
              markdownlint-cli
            ];
          };

          # lazy.nvim does the loading, so everything lives in startupPlugins
          # and optionalPlugins is unused.
          startupPlugins = with pkgs.vimPlugins; {
            general = [
              vim-sleuth
              lazy-nvim
              ts-comments-nvim
              gitsigns-nvim
              which-key-nvim
              nvim-web-devicons
              plenary-nvim
              nvim-lspconfig
              lazydev-nvim
              fidget-nvim
              conform-nvim
              nvim-cmp
              luasnip
              cmp_luasnip
              cmp-nvim-lsp
              cmp-path
              copilot-vim
              onedark-nvim
              todo-comments-nvim
              mini-nvim
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
              flash-nvim
              neogit
              oil-nvim
              no-neck-pain-nvim
              undotree
              vim-visual-multi
              vim-table-mode
              vim-move
              trouble-nvim
              hardtime-nvim
              tiny-inline-diagnostic-nvim
              precognition-nvim
              nvim-treesitter-context
              rainbow-delimiters-nvim
              markview-nvim
              arrow-nvim
              eyeliner-nvim
              snacks-nvim
              nvim-hlslens
              nvim-ts-context-commentstring
              nvim-ts-autotag
              indent-blankline-nvim
              diffview-nvim
              vim-matchup
              satellite-nvim
              vim-slime
              switch-vim
              bufferline-nvim
              grug-far-nvim
              vim-characterize
              highlight-undo-nvim
              incline-nvim
              lensline-nvim
              nvim-dbee
              nvim-colorizer-lua
              spellwarn-nvim
              sidekick-nvim
              persistence-nvim
              substitute-nvim
              vim-illuminate
              dropbar-nvim
              reactive-nvim
              pkgs.neovimPlugins.neojjit
              pkgs.neovimPlugins.myeyeshurt
              pkgs.neovimPlugins.neominimap
              pkgs.neovimPlugins.indent-rainbowline
            ];
            kickstart-debug = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-go
              nvim-nio
              nvim-dap-python
              nvim-dap-vscode-js
              one-small-step-for-vimkind
            ];
            kickstart-lint = [
              nvim-lint
            ];
            kickstart-neo-tree = [
              neo-tree-nvim
              nui-nvim
              # nixCats filters out duplicates, so dependencies can be listed
              # here even though they are also in `general`.
              nvim-web-devicons
              plenary-nvim
            ];
            obsidian = [
              obsidian-nvim
            ];
            orgmode = [
              orgmode
            ];
          };
        };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        nvim =
          { pkgs, ... }:
          {
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [ "vim" ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            # Which categories to build, plus anything else lua should be able
            # to read back through nixCats('<name>').
            categories = {
              general = true;

              kickstart-neo-tree = true;
              kickstart-debug = {
                enabled = true;
                debugpy_python = "${pkgs.python3.withPackages (ps: [ ps.debugpy ])}/bin/python3";
                js_debug_cmd = "${pkgs.vscode-js-debug}/bin/js-debug";
              };
              kickstart-lint = true;

              # These need no extra packages, so they have no entry in
              # categoryDefinitions; they only gate lua config.
              kickstart-autopairs = true; # mini.pairs
              kickstart-indent_line = true; # snacks scope/indent
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
          };
      };
      defaultPackageName = "nvim";
    in

    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # Only for the tooling below; the pkgs that builds neovim is resolved
        # inside the builder.
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [
              defaultPackage
              pkgs.stylua
              pkgs.nixfmt
            ];
          };
        };

        formatter = pkgs.nixfmt-tree;

        # Run by `nix flake check` (and CI).
        checks = {
          # Builds the package, starts it headless and loads every plugin.
          # git is not part of the package (it comes from the user's PATH),
          # but gitsigns and obsidian.nvim expect to find it.
          startup =
            pkgs.runCommand "nvim-startup-check"
              {
                nativeBuildInputs = [
                  defaultPackage
                  pkgs.git
                ];
              }
              ''
                export HOME=$(mktemp -d)
                nvim --headless -c "luafile ${./checks/startup.lua}" -c "qa!"
                touch $out
              '';

          stylua = pkgs.runCommand "stylua-check" { nativeBuildInputs = [ pkgs.stylua ]; } ''
            cd ${self}
            stylua --check .
            touch $out
          '';

          nixfmt = pkgs.runCommand "nixfmt-check" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            nixfmt --check ${self}/flake.nix
            touch $out
          '';
        };
      }
    )
    // (
      let
        # NixOS and home-manager modules that allow reconfiguring the package.
        moduleArgs = {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        nixosModule = utils.mkNixosModules moduleArgs;
        homeModule = utils.mkHomeModules moduleArgs;
      in
      {
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
