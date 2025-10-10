{ lib, vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "neominimap";
  version = "v3.15.3";
  src = fetchFromGitHub {
    owner = "Isrothy";
    repo = "neominimap.nvim";
    rev = "9a40d417374eeb6e2907d0782ecc4d4aeb5006b1";
    sha256 = "0kqq6clgr7xy26j8njc86dr79vx6zpvkq09x1l8zgiaa5mj1q5ni";
  };
  meta = with lib; {
    description = "Fast, feature-rich minimap plugin for Neovim";
    homepage = "https://github.com/Isrothy/neominimap.nvim";
    license = licenses.mit;
  };
}
