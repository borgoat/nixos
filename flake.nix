{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.casual-gator = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/casual-gator/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.borgoat = import ./home.nix;
        }
      ];
    };
    nixosConfigurations.content-pigeon = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./machines/content-pigeon/configuration.nix
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
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/thinkpad/configuration.nix
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

