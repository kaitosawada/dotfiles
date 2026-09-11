{ pkgs, lib, ... }:

{
  programs.java = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    package = pkgs.jdk;
  };
}
