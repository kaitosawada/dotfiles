{ pkgs, ... }:

let
  claudeSettings = {
    alwaysThinkingEnabled = true;
    language = "japanese";
    permissions = {
      allow = [
        "Bash(pnpm build:*)"
        "Bash(pnpm add:*)"
        "Bash(pnpm typecheck:*)"
        "Bash(pnpm lint:*)"
        "Bash(pnpm format:*)"
        "WebSearch"
        "Bash(tail:*)"
        "Bash(head:*)"
        "Bash(grep:*)"
        "Bash(find:*)"
        "Bash(ls:*)"
        "Bash(nixfmt:*)"
        "Bash(gcloud logging read:*)"
        "Bash(gcloud logs read:*)"
        "Bash(gcloud projects list)"
        "Bash(gcloud config get-value project)"
      ];
      deny = [
        "Read(./.env)"
        "Read(./.env.*)"
        "Read(./secrets/**)"
        "Read(./config/credentials.json)"
        "Read(**/*.pem)"
        "Read(**/*.key)"
        "Bash(rm -rf *)"
        "Bash(curl *)"
        "Bash(wget *)"
        "Bash(git push *)"
        "Bash(chmod 777 *)"
      ];
      disableBypassPermissionsMode = "disable";
    };
    env = {
      DISABLE_AUTOUPDATER = "1";
      EDITOR = "nvim-minimal";
    };
    attribution = {
      commit = "";
      pr = "";
    };
    sandbox = {
      enabled = true;
      allowUnsandboxedCommands = false;
      filesystem = {
        denyRead = [
          "~/.aws/credentials"
          "~/.ssh"
        ];
      };
      network = {
        allowedDomains = [
          "api.openai.com"
          "api.github.com"
          "registry.npmjs.org"
          "github.com"
          "oauth2.googleapis.com"
          "logging.googleapis.com"
          "cloudresourcemanager.googleapis.com"
        ];
      };
      allowedCommands = [
        "bash"
        "sh"
        "ls"
        "cat"
        "tail"
        "head"
        "grep"
        "find"
        "gcloud"
        "nixfmt"
      ];
    };
  };

  # mcpServersConfig = {
  #   mcpServers = {
  #     "playwright" = {
  #       type = "stdio";
  #       command = "mcp-server-playwright";
  #       args = [ ];
  #       env = { };
  #     };
  #     "markdownit" = {
  #       type = "stdio";
  #       command = "markitdown-mcp";
  #       args = [ ];
  #       env = { };
  #     };
  #   };
  # };

  # updateScript = pkgs.writeShellScript "update-claude-config" ''
  #   CLAUDE_CONFIG="$HOME/.claude.json"
  #
  #   # 設定ファイルが存在しない場合は作成
  #   if [[ ! -f "$CLAUDE_CONFIG" ]]; then
  #     echo '{}' > "$CLAUDE_CONFIG"
  #   fi
  #
  #   # 新しいmcpServers設定を一時ファイルに書き込み
  #   cat > /tmp/mcp-servers.json << 'EOF'
  #   ${builtins.toJSON mcpServersConfig}
  #   EOF
  #
  #   # 既存の設定とマージ
  #   ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$CLAUDE_CONFIG" /tmp/mcp-servers.json > "$CLAUDE_CONFIG.tmp"
  #   mv "$CLAUDE_CONFIG.tmp" "$CLAUDE_CONFIG"
  #
  #   # 一時ファイルを削除
  #   rm -f /tmp/mcp-servers.json
  # '';
in
{
  home.file.".claude/settings.json" = {
    text = builtins.toJSON claudeSettings;
    force = true;
  };

  # home.activation.updateClaudeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${updateScript}
  # '';

  # 設定変更時に自動更新するための依存関係
  # home.file.".claude-mcp-update".text = builtins.toJSON mcpServersConfig;
}
