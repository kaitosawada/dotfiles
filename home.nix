{
  system,
  username,
  homeDirectory,
  pkgs,
  lib,
  ...
}:
let
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  skkLib = import ./lib/skkeleton.nix { inherit pkgs; };
in
{
  imports = [
    ./programs
    ./claude.nix
  ];

  # See <https://github.com/nix-community/home-manager/blob/master/modules/programs/mise.nix>
  programs.mise = {
    enable = true;
    # See <https://mise.jdx.dev/configuration.html#settings-file-config-mise-settings-toml>
    settings = {
      experimental = true;
    };
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      wget

      # git
      git
      ghq

      # languages
      deno
      bun
      go
      biome

      # nix
      nix-search-cli
      nixfmt-rfc-style

      # tools
      gnumake
      jq
      ripgrep
      sd
      imagemagick
      tree-sitter # for nixvim swift grammar
      ni # @antfu/ni
      google-cloud-sdk # for gcloud CLI

      # docker
      colima
      docker
      docker-compose
      docker-buildx
      docker-credential-helpers

      # rust
      rustc
      cargo

      # js
      nodejs
      yarn
      pnpm

      # python
      python314
      uv

      # llm
      llm

      # claude
      claude-code

      # bitwarden
      bitwarden-cli
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      NIXPKGS_ALLOW_UNFREE = "1";
      DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
      SSH_AUTH_SOCK =
        if isDarwin then
          "${homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
        else
          "${homeDirectory}/.bitwarden-ssh-agent.sock";
    };

    shellAliases = {
      n = ''nvim --listen "/tmp/nvim-$$.pipe"'';
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" --impure && exec $SHELL -l'';
      upgrade = "mise upgrade && nix flake update && nix store gc";
      t = ''zellij attach "$(basename $(pwd))" --create'';
      todo = "(cd $HOME/obsidian/kaitosawada && claude)";
      tl = "(cd $HOME/obsidian/kaitosawada && claude -p 'todo list')";
      zk = "zellij kill-all-sessions";
      d = "gh dash";
      unlock = "bw unlock --raw > ~/.bw_session";
    };
  };

  home.activation.copyMacSKKDict = lib.mkIf isDarwin {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      dictDir="$HOME/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries"
      dictFile="$dictDir/SKK-JISYO.L"
      srcFile="${skkLib.skkDict}/SKK-JISYO.L"
      mkdir -p "$dictDir"
      if [ -L "$dictFile" ]; then
        rm "$dictFile"
      fi
      if [ ! -f "$dictFile" ] || ! cmp -s "$srcFile" "$dictFile"; then
        cp "$srcFile" "$dictFile"
        echo "Copied SKK-JISYO.L to macSKK dictionaries"
      fi
    '';
  };

  nix = {
    package = pkgs.nix;
    settings = {
      "experimental-features" = [
        "nix-command"
        "flakes"
      ];
      cores = 8;
      "max-jobs" = 8;
    };
  };
}
