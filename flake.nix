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
      nixvim,
      flake-utils,
      home-manager,
      # zjstatus,
      ...
    }:
    let
      inputs = {
        inherit nixpkgs home-manager nixvim;
      };
      mkConfig =
        username: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          extraSpecialArgs = {
            inherit inputs username;
            homeDirectory = "/Users/${username}";
          };
          modules = [ ./home.nix ];
        };
    in
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
        kaito = mkConfig "kaito" "aarch64-darwin";
        kaitosawada = mkConfig "kaitosawada" "aarch64-darwin";
        kaitosawada-x86_64-Linux = mkConfig "kaitosawada" "x86_64-linux";
        kaitosawada-arm64-Darwin = mkConfig "kaitosawada" "aarch64-darwin";
        kaito-arm64-Darwin = mkConfig "kaito" "aarch64-darwin";
      };
    };
}
