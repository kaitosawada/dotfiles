{
  pkgs,
  inputs,
  system,
  ...
}:
let
  pi-coding-agent = inputs.llm-agents.packages.${system}.pi;

  piWrapped = pkgs.writeShellScriptBin "pi" ''
    export EDITOR="nvim-minimal"
    exec ${pi-coding-agent}/bin/pi "$@"
  '';
in
{
  programs.pi-coding-agent = {
    enable = true;
    package = piWrapped;
  };

  # Pi settings.json with websearch extension
  home.file.".pi/agent/settings.json" = {
    text = builtins.toJSON {
      extensions = [
        "~/.pi/agent/extensions/websearch.ts"
      ];
      defaultThinkingLevel = "medium";
      defaultProvider = "fireworks";
      defaultModel = "accounts/fireworks/models/kimi-k2p7-code";
    };
  };

  # Websearch extension
  home.file.".pi/agent/extensions/websearch.ts" = {
    source = ./websearch.ts;
  };

  # Respond in Japanese
  home.file.".pi/agent/APPEND_SYSTEM.md" = {
    text = ''
      回答は日本語で行ってください。
    '';
  };
}
