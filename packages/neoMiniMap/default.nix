{ lib, vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "neominimap";
  version = "v3.16.0";
  src = fetchFromGitHub {
    owner = "Isrothy";
    repo = "neominimap.nvim";
    rev = "0676085d898019f06044923934e38663f5efa290";
    sha256 = "076l8knm2dp73vhvkxjvwkcgz1z9cmlgvvczn188mjjyv6cpzi8i";
  };
  # The nixpkgs require-check loads every module in isolation, which fails for
  # neominimap's internal modules (they expect plugin runtime state).
  doCheck = false;
  meta = with lib; {
    description = "Fast, feature-rich minimap plugin for Neovim";
    homepage = "https://github.com/Isrothy/neominimap.nvim";
    license = licenses.mit;
  };
}
