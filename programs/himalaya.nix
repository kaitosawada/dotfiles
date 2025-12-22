{ himalayaPackage, ... }:
{
  programs.himalaya = {
    enable = true;
    package = himalayaPackage;
  };
}
