{ pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  networking = {
    hostName = "content-pigeon";
    interfaces.enp0s3.useDHCP = true;

    nat = {
      enable = true;
      externalInterface = "enp0s3";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      checkReversePath = "loose"; # for tailscale exit node
      allowedUDPPorts = [ 51820 ];
      trustedInterfaces = [ "wg0" ];
    };


    wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.199.1/32" ];
        listenPort = 51820;

        privateKeyFile = "/root/wg-keys/private";

        peers = [
          { # casual-gator
	    endpoint = "138.201.87.57:51820";
            publicKey = "xwJ9i5RSkTEs4pBISHTe1xnvTX2x7rVFmK8kAyXOmxk=";
            allowedIPs = [
              "192.168.199.2/32"
            ];
          }
          { # Mikrotik Pumiro
            publicKey = "qSpmTq/LUQMclxY0EXULYkYYr0pYldOYp2KYCuecg38=";
            allowedIPs = [
              "192.168.199.9/32"
              "192.168.99.0/24"
            ];
            persistentKeepalive = 25;
          }
          # { # Mikrotik Olgiate
          #   publicKey = "";
          #   allowedIPs = [
          #     "192.168.199.8/32"
          #     "192.168.88.0/24"
          #   ];
          #   persistentKeepalive = 25;
          # }
        ];
      };
    };
  };

  boot.cleanTmpDir = true;
  swapDevices = lib.mkForce [ ];
}

