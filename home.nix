{
  inputs,
  system,
  username,
  homeDirectory,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      deno
      git
      go
      ghq
      gnumake
      glow
      lazygit
      lazysql
      jq
      kubectx
      ripgrep
      sd
      docker
      docker-buildx
      gvproxy
      google-cloud-sdk
      nix-search-cli
      go-task
      nodejs_22
      (nodePackages."@antfu/ni".override {
        nodejs = nodejs_22;
      })
      pnpm
      yarn
      duckdb
      nixfmt-rfc-style
      todo-txt-cli
      redis
      # https://github.com/NixOS/nixpkgs/issues/339576
      (
        (bitwarden-cli.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ llvmPackages_18.stdenv.cc ];
          stdenv = llvmPackages_18.stdenv;
        })).override
        { nodejs_20 = nodejs_22; }
      )
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
    };

    shellAliases = {
      n = "nvim";
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" && exec $SHELL -l'';
      tree = "lsd --tree";
      grep = "rg";
      cd = "z";
      t = ''zellij attach "$(basename $(pwd))" --create'';
      unlock = "export BW_SESSION=$(bw unlock --raw)";
    };
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      max-jobs = 8 
      cores = 8
      experimental-features = nix-command flakes
    '';
  };
}
