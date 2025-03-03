{
  system,
  username,
  homeDirectory,
  pkgs,
  ...
}:
{
  imports = [
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
      lazysql
      jq
      ripgrep
      sd
      docker
      docker-buildx
      nix-search-cli
      nodejs_23
      (nodePackages."@antfu/ni".override {
        nodejs = nodejs_23;
      })
      pnpm
      yarn
      # duckdb
      nixfmt-rfc-style
      todo-txt-cli
      redis
      # https://github.com/NixOS/nixpkgs/issues/339576
      (
        (bitwarden-cli.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ llvmPackages_18.stdenv.cc ];
          stdenv = llvmPackages_18.stdenv;

          postInstall = ''
            rm -rf $out/lib/node_modules/@bitwarden/clients/node_modules/.bin
            rm -rf $out/lib/node_modules/@bitwarden/clients/node_modules/@bitwarden
          '';

          postFixup = ''
            wrapProgram $out/bin/bw --set NODE_NO_WARNINGS 1
          '';
        })).override
        { nodejs_20 = nodejs_23; }
      )
      bindfs
      claude-code
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    shellAliases = {
      n = "nvim";
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" --impure && exec $SHELL -l'';
      tree = "lsd --tree";
      grep = "rg";
      cd = "z";
      t = ''zellij attach "$(basename $(pwd))" --create'';
      unlock = "export BW_SESSION=$(bw unlock --raw)";
      gr = ''cd "$(git rev-parse --show-toplevel)"'';
    };
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      max-jobs = 8 
      cores = 8
      experimental-features = nix-command flakes
      trusted-users = root kaitosawada kaito ubuntu
    '';
  };
}
