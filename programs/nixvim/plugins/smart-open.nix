{ pkgs, ... }:
let
  smart-open = pkgs.vimUtils.buildVimPlugin {
    name = "smart-open";
    src = pkgs.fetchFromGitHub {
      owner = "danielfalk";
      repo = "smart-open.nvim";
      rev = "7770b01ce4d551c143d7ec8589879320796621b9";
      hash = "sha256-cnWB5Op48wkSFZM5TcNVUVGp77PN6dZ6al1RsBEL3/s=";
    };
    dependencies = with pkgs.vimPlugins; [
      telescope-nvim
      sqlite-lua
      plenary-nvim
      fzf-lua
    ];
    buildInputs = with pkgs; [
      fd
      ripgrep
      fzf
    ];
  };
in
{
  extraConfigLua = ''
    require("smart-open").setup()
  '';

  extraPlugins = [
    smart-open
  ];

  plugins = {
    sqlite-lua.enable = true;
  };
}
