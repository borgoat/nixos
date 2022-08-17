# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;

    settings.experimental-features = [ "nix-command" "flakes" ];

    gc = {
      automatic = true;
      dates = "weekly";
    };
   };

  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO machine-specific config
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing = {
  #   enable = true;
  #   drivers = [ pkgs.brlaser ];
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.borgoat = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"      # Enable ‘sudo’ for the user.
      "syncthing"  # Allow using syncthing.
      "docker"
      "libvirtd"
      "adbusers"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPC0FZMTGMMkXurkSXD9Pgng8quo12QAZPFUV5lLmTC borgio@manjaropad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ66QbvxQYP+BiN2AVZfJ4SbCZkajDKpqWJYPDTpiFKt termux@mi9"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    android-tools
    dogdns
    du-dust  # A more intuitive version of du in rust
    duf  # A better df alternative
    file  # A program that shows the type of files
    git
    hexyl  # A command-line hex viewer
    wireguard-tools
  ];

  programs.neovim = {
    enable = true;
    configure = {
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
        ];
      };
    };
  };

  programs.adb.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Needed to install NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  services.lorri.enable = true;

  services.syncthing = {
    enable = true;

    user = "borgoat";
    configDir = "/home/borgoat/.config/syncthing";

    devices = {
      "content-pigeon" = { id = "JMWSW2I-4ZR65J2-2Y72NYU-EVOEBOC-D7623KK-TDRAHSF-JP7RZRP-4VVVYQ5"; };
      "thinkpad" = { id = "4Z7BDDH-BQCU2WL-S2H3APJ-2S5MVLQ-PZU2SOB-7OJQRSC-AUMQLSI-UHXLOAM"; };
      "macbook" = { id = "IW3YYMX-AWOW265-73IQGYI-BZZUU52-CLKBKOT-B4JEDZQ-S6J7JQ4-PGL5RAJ"; };
    };

    folders = {
      "Keepass" = {
        id = "jgmne-sxjvp";
        path = "/home/borgoat/Keepass";
	devices = [ "content-pigeon" "thinkpad" "macbook" ];
	versioning = {
	  type = "simple";
	  params.keep = "10";
	};
      };

      "Syncthing" = {
        id = "yi9hu-m36kc";
	path = "/home/borgoat/Documents/Syncthing";
	devices = [ "content-pigeon" "thinkpad" "macbook" ];
	versioning = {
	  type = "simple";
	  params.keep = "10";
	};
      };
    };
  };

  networking.firewall = {
    enable = true;

    # Allow all traffic coming from Tailscale
    trustedInterfaces = [ "tailscale0" ];

    allowedTCPPorts = [
      22000  # Syncthing
      8096   # Jellyfin
    ];

    allowedUDPPorts = [
      22000  # Syncthing
      1900   # Jellyfin
      7359   # Jellyfin
    ];
  };

  services.tailscale.enable = true;

  # virtualisation = {
  #   libvirtd.enable = true;
  #   docker = {
  #     enable = true;
  #     enableOnBoot = false;
  #   };
  # };

  services.jellyfin.enable = true;

}

