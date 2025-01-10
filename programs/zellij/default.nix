# { pkgs, ... }:
{
  programs.zellij = {
    enable = true;
  };
  home.file.".config/zellij/config.kdl" = {
    source = ./config.kdl;
    target = ".config/zellij/config.kdl";
  };
  home.file.".zellij_layout" = {
    text = ''
        layout {
            pane size=1 borderless=true {
                plugin location="tab-bar"
            }
            pane split_direction="vertical" {
                pane size="60%" command="nvim"
                pane split_direction="horizontal" {
                    pane
                    pane
                    pane
                }
            }
            pane size=1 borderless=true {
                plugin location="status-bar"
            }
            new_tab_template {
              pane size=1 borderless=true {
                plugin location="tab-bar"
              }
              pane
              pane size=1 borderless=true {
                plugin location="status-bar"
              }
            }
        }
    '';
    target = ".config/zellij/layouts/default.kdl";
  };
}
