{ pkgs, ... }:
let
  firenvim = pkgs.vimUtils.buildVimPlugin {
    name = "firenvim";
    src = pkgs.fetchFromGitHub {
      owner = "glacambre";
      repo = "firenvim";
      rev = "f8a5fa6f1ed42536490acf0840497c40331c184f";
      hash = "sha256-Kg/kvLfvmzjO5064fCUuvIOxyiPR38bjDbUI/rAexSI=";
    };
  };
in
{
  extraPlugins = [
    firenvim
  ];
}
