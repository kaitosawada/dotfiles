{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  # pi パッケージを宣言的に管理するリスト
  # awesome-pi-coding-agent などの npm パッケージを追加可能
  piPackages = [
    "npm:pi-web-access@0.10.7"
    "npm:@gotgenes/pi-subagents@16.3.1"
    "npm:pi-lean-ctx@3.8.7"
  ];

  # buildNpmPackage で npm パッケージを nix store にビルドし、
  # ~/.pi/agent/npm 以下に配置する
  # 注意: このディレクトリは nix store への symlink なので、
  #       `pi install` や `pi update` は使えない
  piExtensionsNpm = pkgs.buildNpmPackage {
    pname = "pi-extensions";
    version = "0.2.0";
    src = ./npm;
    npmDepsHash = "sha256-1WItim0hrFFOjYlzsxQkc6t4r8NPI6dpH6iYLDTcIXs=";
    npmFlags = [ "--legacy-peer-deps" ];
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -R node_modules $out/
      cp package.json $out/
      cp package-lock.json $out/
    '';
  };

  pi-coding-agent = inputs.llm-agents.packages.${system}.pi;

  piWrapped = pkgs.writeShellScriptBin "pi" ''
    export EDITOR="nvim-minimal"
    exec ${pi-coding-agent}/bin/pi "$@"
  '';

  # pi-lean-ctx が呼び出す lean-ctx バイナリ
  # 公式 GitHub release から取得
  lean-ctx = pkgs.stdenv.mkDerivation rec {
    pname = "lean-ctx";
    version = "3.8.7";

    src =
      let
        platform =
          {
            "aarch64-darwin" = {
              target = "aarch64-apple-darwin";
              hash = "sha256-p3JGAV7ose8jSCmGEGyfsG+uScKY0fzBJB7Fok3Z+Mc=";
            };
            "x86_64-darwin" = {
              target = "x86_64-apple-darwin";
              hash = "sha256-C2h6ScelBfy08BVPlu5LqYU01h3/l7e3Ui0xod5MCNM=";
            };
            "x86_64-linux" = {
              target = "x86_64-unknown-linux-musl";
              hash = "sha256-hip1Lq9wKF9+CJor4FcTyOimmwVBH5YmE4Yvpn4Sab0=";
            };
          }
          .${system} or (throw "lean-ctx: unsupported system ${system}");
      in
      pkgs.fetchurl {
        url = "https://github.com/yvgude/lean-ctx/releases/download/v${version}/lean-ctx-${platform.target}.tar.gz";
        inherit (platform) hash;
      };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin
    '';

    meta = {
      description = "LeanCTX context intelligence binary for AI agents";
      homepage = "https://leanctx.com";
      license = pkgs.lib.licenses.asl20;
      platforms = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    };
  };
in
{
  programs.pi-coding-agent = {
    enable = true;
    package = piWrapped;
  };

  # pi パッケージの実体を nix store から配置
  home.file.".pi/agent/npm" = {
    source = piExtensionsNpm;
  };

  # pi-lean-ctx の MCP bridge / CLI から呼び出される lean-ctx バイナリ
  home.packages = [ lean-ctx ];

  # settings.json の packages 経由で pi 拡張を読み込む
  # API key は環境変数（EXA_API_KEY / PERPLEXITY_API_KEY / GEMINI_API_KEY）
  # または ~/.pi/web-search.json で設定する
  home.file.".pi/agent/settings.json" = {
    text = builtins.toJSON {
      packages = piPackages;
      defaultThinkingLevel = "medium";
      defaultProvider = "fireworks";
      defaultModel = "accounts/fireworks/models/kimi-k2p7-code";
    };
  };

  # Exa API key for pi-web-access
  # secrets/home.yaml に "exa-api-key" が定義されていることを前提
  sops.secrets."exa-api-key" = {
    sopsFile = ../../secrets/home.yaml;
  };

  # pi-web-access の設定ファイル
  # sops で復号した Exa API key を書き出す
  sops.templates."pi-web-search.json" = {
    content = builtins.toJSON {
      exaApiKey = config.sops.placeholder."exa-api-key";
    };
    path = "${config.home.homeDirectory}/.pi/web-search.json";
  };

  # Respond in Japanese
  home.file.".pi/agent/APPEND_SYSTEM.md" = {
    text = ''
      回答は日本語で行ってください。
    '';
  };

  # PR assistant extension
  home.file.".pi/agent/extensions/pr-assistant.ts" = {
    source = ./extensions/pr-assistant.ts;
  };
}
