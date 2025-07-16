{ pkgs, lib, ... }:

let
  mcpServersConfig = {
    mcpServers = {
      "playwright" = {
        type = "stdio";
        command = "mcp-server-playwright";
        args = [];
        env = {};
      };
      "markdownit" = {
        type = "stdio";
        command = "markitdown-mcp";
        args = [];
        env = {};
      };
    };
  };
  
  updateScript = pkgs.writeShellScript "update-claude-config" ''
    CLAUDE_CONFIG="$HOME/.claude.json"
    
    # 設定ファイルが存在しない場合は作成
    if [[ ! -f "$CLAUDE_CONFIG" ]]; then
      echo '{}' > "$CLAUDE_CONFIG"
    fi
    
    # 新しいmcpServers設定を一時ファイルに書き込み
    cat > /tmp/mcp-servers.json << 'EOF'
    ${builtins.toJSON mcpServersConfig}
    EOF
    
    # 既存の設定とマージ
    ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$CLAUDE_CONFIG" /tmp/mcp-servers.json > "$CLAUDE_CONFIG.tmp"
    mv "$CLAUDE_CONFIG.tmp" "$CLAUDE_CONFIG"
    
    # 一時ファイルを削除
    rm -f /tmp/mcp-servers.json
  '';
in
{
  home.activation.updateClaudeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${updateScript}
  '';
  
  # 設定変更時に自動更新するための依存関係
  home.file.".claude-mcp-update".text = builtins.toJSON mcpServersConfig;
}
