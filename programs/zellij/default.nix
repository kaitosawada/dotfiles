{ pkgs, ... }:
let
  # https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm
  zellij-autolock = pkgs.stdenv.mkDerivation {
    name = "zellij-autolock";
    src = pkgs.fetchurl {
      url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm";
      hash = "sha256-aclWB7/ZfgddZ2KkT9vHA6gqPEkJ27vkOVLwIEh7jqQ=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/zellij-autolock.wasm
    '';
  };
in
{
  programs.zellij = {
    enable = true;
  };
  home.file.".config/zellij/config.kdl".text = ''
    theme "catppuccin-macchiato"
    plugins {
      autolock location="file:${zellij-autolock}/bin/zellij-autolock.wasm" {
        is_enabled true
        triggers "nvim"
      }
    }
    load_plugins {
      autolock
    }
    keybinds {
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
  '';
  home.file.".config/zellij/layouts/default.kdl" = {
    source = ./layouts/default.kdl;
    target = ".config/zellij/layouts/default.kdl";
  };
  home.file.".config/zellij/layouts/sd_common_backend.kdl" = {
    source = ./layouts/sd_common_backend.kdl;
    target = ".config/zellij/layouts/sd_common_backend.kdl";
  };

}
