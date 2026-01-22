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
  home.sessionVariables.SSH_AUTH_SOCK = bitwardenAgentSocket;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraConfig = ''
      Include ${homeDirectory}/.colima/ssh_config

      Match host * exec "SSH_AUTH_SOCK=${bitwardenAgentSocket} ssh-add -l >/dev/null 2>&1 || test $? -eq 1"
        IdentityAgent "${bitwardenAgentSocket}"
    '';

    matchBlocks = {
      "github.com" = lib.hm.dag.entryBefore [ "*" ] {
        extraOptions = {
          AddKeysToAgent = "yes";
        }
        // lib.optionalAttrs isDarwin { UseKeychain = "yes"; };
      };

      "i-* mi-*" = {
        proxyCommand = ''sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"'';
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };

      "*.teinei.life" = {
        proxyCommand = "cloudflared access ssh --hostname %h";
        extraOptions = {
          ForwardAgent = "yes";
        };
      };

      "*" = lib.hm.dag.entryAfter [ "github.com" "i-* mi-*" "*.teinei.life" ] { };
    };
  };
}
