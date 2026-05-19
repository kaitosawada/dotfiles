{
  pkgs,
  lib,
  homeDirectory,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraConfig = ''
      Include ${homeDirectory}/.colima/ssh_config
    '';

    settings = {
      "github.com" = lib.hm.dag.entryBefore [ "*" ] (
        {
          AddKeysToAgent = "yes";
        }
        // lib.optionalAttrs isDarwin { UseKeychain = "yes"; }
      );

      "i-* mi-*" = {
        ProxyCommand = ''sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"'';
        StrictHostKeyChecking = "no";
        UserKnownHostsFile = "/dev/null";
      };

      "*.teinei.life" = {
        ProxyCommand = "cloudflared access ssh --hostname %h";
        ForwardAgent = "yes";
      };

      "*.ozonehl.dev" = {
        ProxyCommand = "cloudflared access ssh --hostname %h";
        ForwardAgent = "yes";
      };

      "*" = lib.hm.dag.entryAfter [
        "github.com"
        "i-* mi-*"
        "*.teinei.life"
        "*.ozonehl.dev"
      ] { };
    };
  };
}
