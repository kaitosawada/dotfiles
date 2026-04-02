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
        "Bash(vp build:*)"
        "Bash(vp dev:*)"
        "Bash(vp check:*)"
        "Bash(vp lint:*)"
        "Bash(vp fmt:*)"
        "Bash(vp test:*)"
        "Bash(vp install:*)"
        "Bash(vp i:*)"
        "Bash(vp add:*)"
        "Bash(vp remove:*)"
        "Bash(vp rm:*)"
        "Bash(vp run:*)"
        "Bash(vp exec:*)"
        "Bash(vp dlx:*)"
        "Bash(vp create:*)"
        "Bash(vp list:*)"
        "Bash(vp ls:*)"
        "Bash(vp outdated:*)"
        "Bash(vp update:*)"
        "Bash(vp up:*)"
        "Bash(vp staged:*)"
        "Bash(vp why:*)"
        "Bash(vp info:*)"
        "Bash(vp pack:*)"
        "Bash(vp preview:*)"
        "Bash(vp cache:*)"
        "Bash(vp dedupe:*)"
        "Bash(vp link:*)"
        "Bash(vp unlink:*)"
        "Bash(vp pm:*)"
        "Bash(vp config:*)"
        "Bash(vp migrate:*)"
        "Bash(vp env:*)"
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
        "WebFetch(domain:github.com)"
        "WebFetch(domain:raw.githubusercontent.com)"
        "WebFetch(domain:viteplus.dev)"
        "WebFetch(domain:nodejs.org)"
      ];
      deny = [
        "Read(./.env)"
        "Read(./.env.*)"
        "Read(./secrets/**)"
        "Read(./config/credentials.json)"
        "Read(**/*.pem)"
        "Read(**/*.key)"
        "Bash(rm -rf *)"
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
        allowWrite = [
          "~/.vite-plus"
          "~/Library/Preferences/.wrangler"
        ];
        denyRead = [
          "~/.aws/credentials"
          "~/.ssh"
          "~/.gnupg"
          "~/.config/sops/age"
        ];
      };
      network = {
        allowLocalBinding = true;
        allowedDomains = [
          # Allow APIs and services used by Claude and development tools
          "api.openai.com"
          "api.github.com"
          "registry.npmjs.org"
          "github.com"
          "oauth2.googleapis.com"
          "logging.googleapis.com"
          "cloudresourcemanager.googleapis.com"
          "nodejs.org"
          "*.cloudflare.com"
          "*.github.com"

          # Allow local development domains
          "*.localhost"
          "*.kenpo-web.com"
          "*.ozonehl.dev"
          "*.kenpo.co.jp"
          "*.ozonehl.com"
          "*.riebe.co.jp"
          "*.hamieru.com"
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
        "vp"
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
