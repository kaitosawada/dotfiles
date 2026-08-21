{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cursor-agent = inputs.llm-agents.packages.${system}.cursor-agent;
in
{
  sops.secrets."forgejo-token" = {
    sopsFile = ../secrets/home.yaml;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "cursor-agent" ''
      export FORGEJO_TOKEN="$(cat ${config.sops.secrets."forgejo-token".path})"
      exec ${cursor-agent}/bin/cursor-agent "$@"
    '')
  ];
}
