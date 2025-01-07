{
  programs.zellij = {
    enable = true;
  };
  home.file.".zellijrc" = {
    source = ./zellij.kdl;
    target = ".config/zellij/config.kdl";
  };
}
