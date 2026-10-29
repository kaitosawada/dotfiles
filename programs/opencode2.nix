{
  pkgs,
  system,
  inputs,
  ...
}:
let
  tuiConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    keybinds = {
      editor_open = "ctrl+g";
      messages_first = "home";
    };
    theme = "system";
  };

  opencodeConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    update = "disable";
    share = "manual";
    compaction = {
      auto = true;
    };
    mcp = {
      servers = {
        cloudflare = {
          type = "remote";
          url = "https://mcp.cloudflare.com/mcp";
        };
        sentry = {
          type = "remote";
          url = "https://mcp.sentry.dev/mcp";
        };
      };
    };
    permissions = [
      {
        action = "edit";
        resource = "/nix/store/**";
        effect = "deny";
      }
      {
        action = "external_directory";
        resource = "/nix/store/**";
        effect = "allow";
      }
      {
        action = "external_directory";
        resource = "/private/tmp/**";
        effect = "allow";
      }
      {
        action = "external_directory";
        resource = "/tmp/**";
        effect = "allow";
      }
      {
        action = "external_directory";
        resource = "/var/folders/**";
        effect = "allow";
      }
      {
        action = "question";
        resource = "*";
        effect = "allow";
      }
      {
        action = "webfetch";
        resource = "*";
        effect = "allow";
      }
      {
        action = "websearch";
        resource = "*";
        effect = "allow";
      }
    ];
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
  opencode2 = inputs.llm-agents.packages.${system}.opencode2;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "opencode2" ''
      export EDITOR="nvim-minimal"
      exec ${opencode2}/bin/opencode2 "$@"
    '')
  ];

  xdg.configFile."opencode/tui.json".text = tuiConfig;

  xdg.configFile."opencode/opencode.jsonc".text = opencodeConfig;
}
