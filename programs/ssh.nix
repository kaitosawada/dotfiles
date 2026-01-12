{
  pkgs,
  lib,
  homeDirectory,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  bitwardenAgentSocket =
    if isDarwin then
      "${homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    else
      "${homeDirectory}/.bitwarden-ssh-agent.sock";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraConfig = ''
      Include ${homeDirectory}/.colima/ssh_config
    '';

    matchBlocks = {
      "github.com" = lib.hm.dag.entryBefore [ "*" ] {
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = if isDarwin then "yes" else "no";
        };
      };

      "i-* mi-*" = {
        proxyCommand = ''sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"'';
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };

      "*" = lib.hm.dag.entryAfter [ "github.com" "i-* mi-*" ] {
        extraOptions = {
          IdentityAgent = ''"${bitwardenAgentSocket}"'';
        };
      };
    };
  };
}
