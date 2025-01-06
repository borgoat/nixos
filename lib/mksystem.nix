{ nixpkgs, inputs }:

name:
{
  system,
  user,
  graphical ? false,
}:

let
  machineConfig = ../machines/${name}/configuration.nix;
  homeConfig = ../users/${user}/home.nix;

  home-manager = inputs.home-manager.nixosModules;
in
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    machineConfig
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import homeConfig;
      home-manager.extraSpecialArgs = {
        graphical = graphical;
      };
    }
  ];
}
