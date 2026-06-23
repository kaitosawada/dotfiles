{ pkgs, system, inputs, ... }:
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
  opencode = inputs.llm-agents.packages.${system}.opencode;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "opencode" ''
      export EDITOR="nvim-minimal"
      exec ${opencode}/bin/opencode "$@"
    '')
  ];

  xdg.configFile."opencode/tui.json".text = tuiConfig;

  xdg.configFile."opencode/opencode.jsonc".text = opencodeConfig;
}
