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
  ];

  # buildNpmPackage で npm パッケージを nix store にビルドし、
  # ~/.pi/agent/npm 以下に配置する
  # 注意: このディレクトリは nix store への symlink なので、
  #       `pi install` や `pi update` は使えない
  piExtensionsNpm = pkgs.buildNpmPackage {
    pname = "pi-extensions";
    version = "0.10.7";
    src = ./npm;
    npmDepsHash = "sha256-9v/F4d6yv/hEUjhK+qASApjmKSEN2S63dfV0JSgsw4Q=";
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

  # settings.json の packages 経由で pi-web-access を読み込む
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
}
