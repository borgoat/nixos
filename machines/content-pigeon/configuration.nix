{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  networking = {
    hostName = "content-pigeon";
    firewall.checkReversePath = "loose"; # for tailscale
    interfaces.enp0s3.useDHCP = true;

    nat = {
      enable = true;
      externalInterface = "enp0s3";
      internalInterfaces = [ "wg0" ];
    };

    firewall.allowedUDPPorts = [ 51820 ];

    wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.199.1/24" ];
	listenPort = 51820;

	privateKeyFile = "/root/wg-keys/private";

	peers = [
	  { # Mikrotik Pumiro
	    publicKey = "qSpmTq/LUQMclxY0EXULYkYYr0pYldOYp2KYCuecg38=";
	    allowedIPs = [
	      "192.168.199.0/24"
	      "192.168.99.0/24"
	    ];
	    persistentKeepalive = 25;
	  }
	];
      };
    };
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
}

