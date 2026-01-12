{ pkgs, lib, ... }:

{
  home.file.".config/karabiner/karabiner.json" = lib.mkIf pkgs.stdenv.isDarwin {
    source = ../karabiner/karabiner.json;
    force = true;
  };
}
