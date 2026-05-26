{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services.colima = {
      enable = true;
      profiles.default = {
        isActive = true;
        isService = true;
        setDockerHost = true;
      };
    };
  };
}
