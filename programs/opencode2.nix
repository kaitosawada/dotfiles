{
  pkgs,
  system,
  inputs,
  ...
}:
let
  agentsMd = ''
    # Git 運用

    - 基本的に `develop` ブランチへ直接コミットする。作業ブランチを切るのは、ユーザーが明示的に指示した場合のみにする。
    - `develop` が存在しないリポジトリでは、そのリポジトリの既定ブランチに従う。
    - 実装が終わったら、実装範囲の変更を必ずコミットする。未コミットのまま作業を終えない。
    - コミットには実装範囲の変更だけを含め、無関係な変更や整形だけの差分を混ぜない。
    - コミット前に、そのリポジトリの AGENTS.md / CLAUDE.md に書かれた build・lint・format を実行する。
    - コミットメッセージは、そのリポジトリの既存のスタイルに合わせる。
  '';

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
    model = "opencode-go/deepseek-v4.1-flash";
    update = "disable";
    share = "manual";
    agents = {
      docs = {
        description = "Writes and edits documentation: README, design docs, guides, and comments. Use this agent whenever the work is documentation rather than implementation.";
        mode = "all";
        model = "opencode-go/gemini-3.8-flash";
      };
    
    };
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

  xdg.configFile."opencode/AGENTS.md".text = agentsMd;

  xdg.configFile."opencode/tui.json".text = tuiConfig;

  xdg.configFile."opencode/opencode.jsonc".text = opencodeConfig;
}
