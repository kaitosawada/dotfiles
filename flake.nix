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
        strListToAttrs =
          list: f:
          builtins.listToAttrs (
            map (x: {
              name = "${x}-${system}";
              value = f x;
            }) list
          );
        homeDir = if system == "aarch64-darwin" then "/Users" else "/home";
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
                  inherit username system;
                  homeDirectory = "${homeDir}/${username}";
                };
                modules = [
                  ./home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              }
            );
        formatter = treefmtEval.config.build.wrapper;
      }
    );
}
