{ pkgs, ... }:
let
  skkDict = pkgs.stdenv.mkDerivation {
    name = "skk-jisyo";
    src = pkgs.fetchurl {
      url = "https://skk-dev.github.io/dict/SKK-JISYO.M.gz";
      sha256 = "sha256-YYGO7TWXEBJaVNHGrG6vr+/nzEIKgPdwpH9JJHq10Ug=";
    };
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    unpackPhase = ''
      gzip -d $src -c > SKK-JISYO.M
    '';
    installPhase = ''
      mkdir -p $out
      mv SKK-JISYO.M $out
    '';
  };
in
{
  home.file.".skk-jisyo".source = "${skkDict}/SKK-JISYO.M";
}
