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
