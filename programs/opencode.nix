{ pkgs, lib, ... }:
let
  tuiConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    keybinds = {
      editor_open = "ctrl+g";
      messages_first = "home";
    };
  };

  opencodeConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    autoupdate = false;
    share = "manual";
    compaction = {
      auto = true;
      prune = false;
    };
    permission = {
      websearch = "allow";
      webfetch = "allow";
      question = "allow";
    };
    watcher = {
      ignore = [
        "node_modules/**"
        "dist/**"
        ".git/**"
        "target/**"
        "result/**"
        "*.tmp"
      ];
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

  xdg.configFile."opencode/opencode.jsonc".text = opencodeConfig;
}
