{ pkgs, ... }:
let
  zellij-nav = pkgs.vimUtils.buildVimPlugin {
    name = "zellij-nav";
    src = pkgs.fetchFromGitHub {
      owner = "swaits";
      repo = "zellij-nav.nvim";
      rev = "91cc2a642d8927ebde50ced5bf71ba470a0fc116";
      hash = "sha256-OoxvSmZV6MCYKrH2ijGqIYhdSZG5oaRj+NFJGt0viyk=";
    };
  };
in
{
  extraConfigLua = ''
    require("zellij-nav").setup()
  '';

  extraPlugins = [
    zellij-nav
  ];
}
