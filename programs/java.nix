{ pkgs, lib, ... }:

{
  programs.java = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    package = pkgs.jdk;
  };
}
