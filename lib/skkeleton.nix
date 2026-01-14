{ pkgs }:
{
  skkDict = pkgs.stdenv.mkDerivation {
    name = "skk-jisyo";
    src = pkgs.fetchurl {
      url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
      sha256 = "sha256-QjbhriumZ1IJIvxapAb3fY4w81kEIdNPQfRq9kG7SKo=";
    };
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    unpackPhase = ''
      gzip -d $src -c > SKK-JISYO.L
    '';
    installPhase = ''
      mkdir -p $out
      mv SKK-JISYO.L $out
    '';
  };
}
