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
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      homeConfigurations = {
        kaitosawada = home-manager.lib.homeManagerConfiguration {
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
        kaito = home-manager.lib.homeManagerConfiguration {
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
      };
    };
}
