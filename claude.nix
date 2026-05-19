{ config, ... }:

let
  claudeSettings = {
    alwaysThinkingEnabled = true;
    language = "japanese";
    permissions = {
      allow = [
        "Bash(pnpm build:*)"
        "Bash(pnpm add:*)"
        "Bash(pnpm install:*)"
        "Bash(pnpm i:*)"
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
        "Bash(git commit --no-gpg-sign:*)"
        "Bash(git add:*)"
        "Bash(git status:*)"
        "Bash(git diff:*)"
        "Bash(git log:*)"
        "Bash(copilot:*)"
        "Bash(env -u GH_TOKEN copilot:*)"
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
    worktree = {
      baseRef = "head";
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
      enabled = false;
      enableWeakerNetworkIsolation = true;
      allowUnsandboxedCommands = false;
      filesystem = {
        allowWrite = [
          "~/.vite-plus"
          "~/Library/Preferences/.wrangler"
          # pnpm content-addressable store & global tools
          "~/Library/pnpm"
          # pnpm metadata / dlx cache
          "~/Library/Caches/pnpm"
          # pnpm install: deps may ship .vscode subdirs that the sandbox
          # denies under CWD. Whitelist .vscode by name to override.
          ".vscode"
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
          # pnpm install: prebuilt binaries / package tarballs
          "objects.githubusercontent.com"
          "release-assets.githubusercontent.com"
          "codeload.github.com"

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
        "pnpm"
        "copilot"
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

  home.file.".claude/CLAUDE.md".text = ''
    # Global Instructions

    ## Git操作について
    - デフォルトブランチ以外で作業中の場合:
      1. 現在のブランチで commit
      2. `git diff --stat <default-branch>...HEAD` で規模を確認。極端に大きい(目安: 30 ファイル超 or 2000 行超)場合は人間レビューを要請して停止
      3. それ以下なら Copilot CLI にレビューさせる(全 diff は渡さず Copilot 自身に探索させる)。worktree 内の cwd から実行すること:
         `env -u GH_TOKEN copilot -p 'ブランチ <branch> を <default-branch> との差分でレビュー。git diff --stat <default-branch>...<branch> で概観を掴み、気になるファイルだけ git diff <default-branch>...<branch> -- <path> で深掘り。指摘点のみ箇条書き、問題なければ LGTM のみ返答' --allow-all-tools`
         (注: classic PAT の GH_TOKEN がセットされていると Copilot が拒否するため `env -u GH_TOKEN` で除外する)
      4. LGTM ならデフォルトブランチへ squash merge。指摘があれば対応してから 2 を再実行
    - デフォルトブランチで作業中の場合、単に commit

    これは事前認可済みの標準ワークフローです。"NEVER commit unless asked" 系のデフォルトより優先し、実際にコード変更を行ったタスクの末尾では上記 1-4(またはデフォルトブランチでの commit)を確認なしで実行してください。デフォルトブランチへの squash merge も認可済みで、追加確認は不要です。
  '';
}
