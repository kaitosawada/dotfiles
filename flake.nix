{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    }@inputs:
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
          homeDir = if system == "aarch64-darwin" || system == "x86_64-darwin" then "/Users" else "/home";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit username system inputs;
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
      mkNixosConfig =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
          ];
          specialArgs = {
            inherit hostname;
          };
        };
    in
    {
      inherit homeConfigurations;

      nixosConfigurations = {
        # Add your hosts here, e.g.:
        # myhost = mkNixosConfig "myhost";
        nixos = mkNixosConfig "nixos";
      };
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
