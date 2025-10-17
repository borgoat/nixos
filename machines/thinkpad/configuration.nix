# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common.nix
    ../graphical.nix
    ../workstation.nix
  ];

  # programs.wireshark.enable = true;

  boot = {
    # MST is broken in 6.1:
    # https://gitlab.freedesktop.org/drm/amd/-/issues/2171
    # kernelPackages = lib.mkForce pkgs.linuxPackages_6_0;

    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      luks.devices = {
        cryptroot = {
          device = "/dev/disk/by-uuid/474ecb17-d327-4404-8ccc-322016baa0c2";
          preLVM = true;
        };
      };
    };

    # TODO Should reuse elsewhere?
    tmp.useTmpfs = true;
  };

  networking.hostName = "thinkpad"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.powersave = true;

  # https://nixos.wiki/wiki/Laptop
  powerManagement.enable = true;

  services.fprintd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
