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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWMViPgAGd1wSRb8fOJHMBcVo/uTw4OcQwI0hx0mupr borgoat@macbook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+HQ9MPR83svLzu43870/0HfYMGVMo2kXls9r4sEL8N borgoat@Giorgios-MacBook-Pro.local"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  services.syncthing = {
    enable = true;

    user = "borgoat";
    configDir = "/home/borgoat/.config/syncthing";

    devices = {
      "casual-gator"   = { id = "CJMWOSW-VBZCFUL-ARN7LPD-SNZWWRM-IBZHZZA-EBBXZZV-FM4HEPJ-63DAZA5"; };
      "content-pigeon" = { id = "JMWSW2I-4ZR65J2-2Y72NYU-EVOEBOC-D7623KK-TDRAHSF-JP7RZRP-4VVVYQ5"; };
      "macbook"        = { id = "IW3YYMX-AWOW265-73IQGYI-BZZUU52-CLKBKOT-B4JEDZQ-S6J7JQ4-PGL5RAJ"; };
      "macbook-pro"    = { id = "OZWTJVP-WYWYMZE-JBX7IY4-V52W42E-66HTYPO-C7IDAC3-WG3F6AR-WJHBCQR"; autoAcceptFolders = true; };
      "MI9"            = { id = "VZ6WQZ4-IPLJA7R-OYNX4KB-WIHB256-NU5LLV5-IM2NPTV-DFC5UZG-VWWLLQK"; autoAcceptFolders = true; };
    };
  };

  networking.firewall = {
    enable = true;

    # Allow all traffic coming from Tailscale
    trustedInterfaces = [ "tailscale0" ];

    allowedTCPPorts = [
      22000  # Syncthing
    ];

    allowedUDPPorts = [
      22000  # Syncthing
    ];
  };

  services.tailscale.enable = true;
}

