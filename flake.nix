{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/tower/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.borgoat = import ./home.nix;
        }
      ];
    };
    nixosConfigurations.macbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/macbook/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.borgoat = import ./home.nix;
        }
      ];
    };
  };
}

