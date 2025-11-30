{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
  home.file.".config/zellij/config.kdl".text = ''
    theme "catppuccin-macchiato"
    keybinds {
      unbind "Ctrl b"
      unbind "Ctrl p"
      shared_except "locked" {
        unbind "Ctrl g"
      }
      shared_except "pane" "locked" {
        unbind "Ctrl p"
      }
      normal {
        bind "Ctrl l" { GoToNextTab; }
        bind "Ctrl h" { GoToPreviousTab; }
        bind "Ctrl j" { FocusNextPane; }
        bind "Ctrl k" { FocusPreviousPane; }
        bind "Super w" { CloseFocus; }
        bind "Super t" { NewTab; }
        bind "Super n" { NewPane; }
        bind "Ctrl q" { Detach; }
        bind "Ctrl Shift q" { Quit; }
        bind "Super f" { ToggleFocusFullscreen; }
      }
      scroll {
        bind "Ctrl l" { GoToNextTab; SwitchToMode "normal"; }
        bind "Ctrl h" { GoToPreviousTab; SwitchToMode "normal"; }
        bind "Ctrl j" { FocusNextPane; SwitchToMode "normal"; }
        bind "Ctrl k" { FocusPreviousPane; SwitchToMode "normal"; }
        bind "Super w" { CloseFocus; SwitchToMode "normal"; }
        bind "Super t" { NewTab; SwitchToMode "normal"; }
        bind "Super n" { NewPane; SwitchToMode "normal"; }
        bind "Ctrl q" { Detach; }
        bind "Ctrl Shift q" { Quit; }
        bind "Super f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
      }
      locked {
        bind "Super t" { NewTab; }
        bind "Super n" { NewPane; }
        bind "Ctrl q" { Detach; }
        bind "Ctrl Shift q" { Quit; }
      }
    }
    ui {
      pane_frames {
        rounded_corners true
      }
    }
    session_serialization false
    mouse_mode false
  '';
  home.file.".config/zellij/layouts/default.kdl" = {
    source = ./layouts/default.kdl;
    target = ".config/zellij/layouts/default.kdl";
  };
}
