{ pkgs, config, ... }:

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
        "Bash(gh run *)"
        "Bash(gh clone *)"
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
      GH_TOKEN = config.sops.placeholder."gh-token";
    };
    attribution = {
      commit = "";
      pr = "";
    };
    sandbox = {
      enabled = true;
      enableWeakerNetworkIsolation = true;
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
        "gh"
      ];
    };
  };
in
{
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."gh-token" = {
    sopsFile = ./secrets/home.yaml;
  };

  sops.templates."claude-settings.json" = {
    content = builtins.toJSON claudeSettings;
    path = "${config.home.homeDirectory}/.claude/settings.json";
  };
}
