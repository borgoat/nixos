# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "pata_atiixp" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelParams = [ "iommu=pt" "amd_iommu=on" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks = {
    devices."root" = {
      device = "/dev/disk/by-uuid/47a7c0df-db2a-48ea-9d1a-a648925669fa";
      preLVM = false;
    };

    devices."home" = {
      device = "/dev/disk/by-uuid/e438cece-1851-4b5a-a992-52b494cd2d05";
      preLVM = false;
    };

    devices."oldhome" = {
      device = "/dev/disk/by-uuid/cfcd3b95-5885-4bd5-ac94-1a91f9f3daaa";
      preLVM = true;
    };

    reusePassphrases = true;
  };


  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0AEA-DD6F";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d498f08b-5570-4113-b342-9f3e88561330";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/43cf2c7f-a3db-42c6-a697-0b770c01f0c5";
      fsType = "ext4";
    };

  fileSystems."/oldhome" =
    { device = "dev/disk/by-uuid/1395cb5d-12bf-4a0e-99d6-137bf5fad22c";
      fsType = "ext4";
      options = [ "ro" ];
    };


  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  services.xserver.videoDrivers = [ "nvidia" ];
}
