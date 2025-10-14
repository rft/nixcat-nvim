{ lib
, vimUtils
, fetchFromGitHub
, indent-blankline-nvim
}:

vimUtils.buildVimPlugin {
  pname = "indent-rainbowline-nvim";
  version = "2024-10-08";
  src = fetchFromGitHub {
    owner = "TheGLander";
    repo = "indent-rainbowline.nvim";
    rev = "572e8157de85d7af3f0085b5c74c059518900649";
    sha256 = "11y1g7njfy9pd2gk9vv6n8921k7ynb4n4hpl9xb9cqwgpjsws9bm";
  };
  meta = with lib; {
    description = "Generate rainbow indent configuration for indent-blankline.nvim";
    homepage = "https://github.com/TheGLander/indent-rainbowline.nvim";
    license = licenses.mit;
  };
  dependencies = [ indent-blankline-nvim ];
}
