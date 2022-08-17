{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Use GRUB2 as the boot loader.
  # We don't use systemd-boot because Hetzner uses BIOS legacy boot.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    devices = [ "/dev/sda" "/dev/sdb" ];
  };

  # The mdadm RAID1s were created with 'mdadm --create ... --homehost=hetzner',
  # but the hostname for each machine may be different, and mdadm's HOMEHOST
  # setting defaults to '<system>' (using the system hostname).
  # This results mdadm considering such disks as "foreign" as opposed to
  # "local", and showing them as e.g. '/dev/md/hetzner:root0'
  # instead of '/dev/md/root0'.
  # This is mdadm's protection against accidentally putting a RAID disk
  # into the wrong machine and corrupting data by accidental sync, see
  # https://bugzilla.redhat.com/show_bug.cgi?id=606481#c14 and onward.
  # We do not worry about plugging disks into the wrong machine because
  # we will never exchange disks between machines, so we tell mdadm to
  # ignore the homehost entirely.
  environment.etc."mdadm.conf".text = ''
    HOMEHOST <ignore>
  '';
  # The RAIDs are assembled in stage1, so we need to make the config
  # available there.
  boot.initrd.services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;

  networking = {
    hostName = "casual-gator";

    # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
    useDHCP = false;
    interfaces."enp0s31f6".ipv4.addresses = [
      {
        address = "138.201.87.57";
        prefixLength = 26;
      }
    ];
    interfaces."enp0s31f6".ipv6.addresses = [
      {
        address = "2a01:4f8:172:22e7::1";
        prefixLength = 64;
      }
    ];
    defaultGateway = "138.201.87.1";
    defaultGateway6 = { address = "fe80::1"; interface = "enp0s31f6"; };
    nameservers = [ "8.8.8.8" ];

    nat = {
      enable = true;
      externalInterface = "enp0s31f6";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      checkReversePath = "loose"; # for tailscale exit node
      allowedUDPPorts = [ 51820 ];
      trustedInterfaces = [ "wg0" ];
    };

    wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.199.2/24" ];
        listenPort = 51820;

        privateKeyFile = "/root/wg-keys/private";

        peers = [
          { # Mikrotik Pumiro
            publicKey = "qSpmTq/LUQMclxY0EXULYkYYr0pYldOYp2KYCuecg38=";
            allowedIPs = [
              "192.168.199.9/32"
              "192.168.99.0/24"
            ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

}
