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
    let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config = {
          allowUnfree = true;
        };
        # overlays = [
        #   (final: prev: {
        #     zjstatus = zjstatus.packages.${prev.system}.default;
        #   })
        # ];
      };
    in
    {
      homeConfigurations = {
        kaitosawada = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            username = "kaitosawada";
            homeDirectory = "/Users/kaitosawada";
          };
          modules = [ ./home.nix ];
        };
        kaito = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
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
