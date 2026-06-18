{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}:
let
  omp = inputs.llm-agents.packages.${system}.omp;
  ompWrapped = pkgs.writeShellScriptBin "omp" ''
    export EDITOR="nvim-minimal"
    exec ${omp}/bin/omp "$@"
  '';
in
{
  home.packages = [ ompWrapped ];

  programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
    # Oh My Pi (omp) shell completions
    eval "$(${omp}/bin/omp completions zsh)"
  '';

  home.file.".omp/config.yml".text = ''
    # Oh My Pi (omp) configuration
    # Documentation: https://github.com/can1357/oh-my-pi/tree/main/docs
    # Official site: https://ohmypi.xyz

    statusLine:
      segmentOptions:
        path:
          abbreviate: true
          maxLength: 20
          stripWorkPrefix: true
  '';

  home.file.".omp/agent/models.yml".text = ''
    # Custom model definitions for Oh My Pi
    # See docs/models.md for the full schema
    providers: {}
    #   openai:
    #     baseUrl: https://api.openai.com/v1
    #     api: openai-completions
    #     apiKey: ''${OPENAI_API_KEY}
  '';
}
