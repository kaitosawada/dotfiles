# { pkgs, ... }:
{
  programs.zellij = {
    enable = true;
  };
  home.file.".config/zellij/config.kdl" = {
    source = ./config.kdl;
    target = ".config/zellij/config.kdl";
  };
  home.file.".config/zellij/layouts/default.kdl" = {
    source = ./layouts/default.kdl;
    target = ".config/zellij/layouts/default.kdl";
  };
  home.file.".config/zellij/layouts/sd_common_backend.kdl" = {
    source = ./layouts/sd_common_backend.kdl;
    target = ".config/zellij/layouts/sd_common_backend.kdl";
  };
}
