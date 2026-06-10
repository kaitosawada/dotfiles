{ pkgs, lib, ... }:
let
  tuiConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    keybinds = {
      editor_open = "ctrl+g";
      messages_first = "home";
    };
  };
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "opencode" ''
      export EDITOR="nvim-minimal"
      exec ${pkgs.opencode}/bin/opencode "$@"
    '')
  ];

  xdg.configFile."opencode/tui.json".text = tuiConfig;
}
