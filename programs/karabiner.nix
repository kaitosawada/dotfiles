{ pkgs, lib, ... }:

{
  home.file.".config/karabiner/karabiner.json" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    source = ../karabiner/karabiner.json;
    force = true;
  };
}
