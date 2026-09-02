{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets."forgejo-token" = {
    sopsFile = ../secrets/home.yaml;
  };

  home.packages = [ pkgs.forgejo-cli ];

  home.activation.seedForgejoFj = lib.hm.dag.entryAfter [ "sops-nix" ] ''
    token=$(cat ${lib.escapeShellArg config.sops.secrets."forgejo-token".path})
    $DRY_RUN_CMD ${pkgs.forgejo-cli}/bin/fj auth logout git.ozonehl.dev || true
    $DRY_RUN_CMD ${pkgs.forgejo-cli}/bin/fj -H git.ozonehl.dev auth add-token "$token"
  '';
}
