{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
    }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
    in
    {
      nixosConfigurations = {

        casual-gator = mkSystem "casual-gator" {
          system = "x86_64-linux";
          user = "borgoat";
        };

        content-pigeon = mkSystem "content-pigeon" {
          system = "aarch64-linux";
          user = "borgoat";
        };

        macbook = mkSystem "macbook" {
          system = "x86_64-linux";
          user = "borgoat";
          graphical = true;
        };

        thinkpad = mkSystem "thinkpad" {
          system = "x86_64-linux";
          user = "borgoat";
          graphical = true;
        };

      };
    };
}
