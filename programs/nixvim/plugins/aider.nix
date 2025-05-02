{ pkgs, ... }:
let
  aider = pkgs.vimUtils.buildVimPlugin {
    name = "aider";
    src = pkgs.fetchFromGitHub {
      owner = "joshuavial";
      repo = "aider.nvim";
      rev = "1e5fc680a764d2b93f342005d7e4415fec469088";
      hash = "sha256-JJP1om3cJQC1/0wh2GFQCnMhPBgCKsiLZxc+xiuxjzg=";
    };
  };
in
{
  extraPlugins = [
    aider
  ];

  extraConfigLua = ''
    require("aider").setup()
  '';
}
