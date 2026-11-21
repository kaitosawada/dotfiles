{
  pkgs,
  config,
  lib,
  system,
  inputs,
  ...
}:
let
  dsh = inputs.llm-agents.packages.${system}.dsh;

  # Reuse the OpenCode Go subscription credential unless the environment
  # already provides one.
  opencodeAuthFile = "${config.xdg.dataHome}/opencode/auth.json";

  # Seeded into the web profile's user layer on the first switch only.
  # Everything here stays editable from Settings -> Models in the Web UI.
  webProfilePatch = ''
    # Seeded by programs/dsh.nix; edit freely afterwards.
    - id: llm-pi-ai
      config:
        providers:
          opencode-go:
            displayName: OpenCode Go
            apiKeyEnv: OPENCODE_API_KEY
            api: openai-completions
            baseURL: https://opencode.ai/inference/go/openai/v1
            models:
              - id: deepseek-v4.1-flash
                name: DeepSeek V4.1 Flash
                contextWindow: 1000000
                maxTokens: 384000
                input:
                  - text
                  - image
                reasoningEfforts:
                  low: low
                  high: high
                  max: max
    - id: agent-default-model
      config:
        provider: opencode-go
        model: deepseek-v4.1-flash
  '';
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "dsh" ''
      export EDITOR="nvim-minimal"
      export VISUAL="nvim-minimal"

      if [ -z "''${OPENCODE_API_KEY:-}" ] && [ -r "${opencodeAuthFile}" ]; then
        key=$(${lib.getExe pkgs.jq} -r '."opencode-go".key // empty' "${opencodeAuthFile}" 2>/dev/null) || key=
        if [ -n "$key" ]; then
          OPENCODE_API_KEY="$key"
          export OPENCODE_API_KEY
        fi
      fi

      exec ${lib.getExe dsh} "$@"
    '')
  ];

  home.activation.dshSeedWebProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    patch="$HOME/.dsh/profiles/web/cordis.patch.yml"
    if [ ! -e "$patch" ]; then
      run mkdir -p "$(dirname "$patch")"
      run install -m 0644 ${pkgs.writeText "dsh-web-cordis.patch.yml" webProfilePatch} "$patch"
    fi
  '';
}
