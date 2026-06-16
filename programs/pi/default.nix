{
  pkgs,
  inputs,
  system,
  ...
}:
let
  piPackages = [
    "npm:pi-web-access@0.10.7"
  ];

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

  # Pi npm package directory
  home.file.".pi/agent/npm" = {
    source = piExtensionsNpm;
  };

  # Pi settings.json with pi-web-access package
  home.file.".pi/agent/settings.json" = {
    text = builtins.toJSON {
      packages = piPackages;
      defaultThinkingLevel = "medium";
      defaultProvider = "fireworks";
      defaultModel = "accounts/fireworks/models/kimi-k2p7-code";
    };
  };

  # Respond in Japanese
  home.file.".pi/agent/APPEND_SYSTEM.md" = {
    text = ''
      回答は日本語で行ってください。
    '';
  };
}
