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
    nix-ai-tools.url = "github:numtide/nix-ai-tools";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      nixvim,
      home-manager,
      treefmt-nix,
      nix-ai-tools,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      mkHomeConfig =
        system: username:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          aipkgs = nix-ai-tools.packages.${system};
          homeDir = if system == "aarch64-darwin" || system == "x86_64-darwin" then "/Users" else "/home";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit username system aipkgs;
            homeDirectory = "${homeDir}/${username}";
          };
          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
          ];
        };

      homeConfigurations = builtins.listToAttrs (
        builtins.concatMap (
          system:
          map
            (username: {
              name = "${username}-${system}";
              value = mkHomeConfig system username;
            })
            [
              "kaito"
              "kaitosawada"
              "ubuntu"
            ]
        ) systems
      );
    in
    {
      inherit homeConfigurations;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        formatter = treefmtEval.config.build.wrapper;
      }
    );
}
