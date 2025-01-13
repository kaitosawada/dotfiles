{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      nixvim,
      home-manager,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        inputs = {
          inherit home-manager nixvim;
        };

        strListToAttrs =
          list: f:
          builtins.listToAttrs (
            map (x: {
              name = "${x}-${system}";
              value = f x;
            }) list
          );

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        packages.homeConfigurations =
          strListToAttrs
            [
              "kaito"
              "kaitosawada"
            ]
            (
              username:
              home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {
                  inherit inputs username system;
                  homeDirectory = "/Users/${username}";
                };
                modules = [ ./home.nix ];
              }
            );
        formatter = treefmtEval.config.build.wrapper;
      }
    );
}
