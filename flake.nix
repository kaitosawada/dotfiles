{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zjstatus = {
    #   url = "github:dj95/zjstatus";
    # };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      home-manager,
      # zjstatus,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.hello
            ];
          };
        };
      }
    )
    // {
      homeConfigurations = {
        kaitosawada-arm64-Darwin = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config = {
              allowUnfree = true;
            };
          };
          extraSpecialArgs = {
            inherit inputs;
            username = "kaitosawada";
            homeDirectory = "/Users/kaitosawada";
          };
          modules = [ ./home.nix ];
        };
        kaitosawada-x86_64-Linux = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          extraSpecialArgs = {
            inherit inputs;
            username = "kaitosawada";
            homeDirectory = "/home/kaitosawada";
          };
          modules = [ ./home.nix ];
        };
      };
    };
}
