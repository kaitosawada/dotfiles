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
      home-manager,
      # zjstatus,
      ...
    }@inputs:
    {
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
