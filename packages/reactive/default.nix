{ lib, vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "reactive-nvim";
  version = "2025-03-16";
  src = fetchFromGitHub {
    owner = "rasulomaroff";
    repo = "reactive.nvim";
    rev = "0588b5c2b0cf49bd2232fe4366b3516c32edee44";
    sha256 = "1qrpyrzmjm9788dppkcjdrjz1hqpvfs95vd0602xbi0cgs2gaq8p";
  };
  meta = with lib; {
    description = "Neovim plugin for dynamic reactive highlights based on mode and operator";
    homepage = "https://github.com/rasulomaroff/reactive.nvim";
    license = licenses.asl20;
  };
}
