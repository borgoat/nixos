# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "weekly";
    };
   };

  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Keyboards
    layout = "us,it";
  };
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    du-dust  # A more intuitive version of du in rust
    duf  # A better df alternative
    file  # A program that shows the type of files
    firefox
    git
    gnome3.gnome-tweaks
    gnomeExtensions.espresso
    hexyl  # A command-line hex viewer
    jetbrains.clion
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.webstorm
    keepassxc
    neovim
    signal-desktop
    zoom-us
  ];

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
      "tower" = { id = "PPTQPL4-FBVHDON-LQZ7NXU-ZHL64FA-C6A6CCR-2BNL5JO-CI3LCE6-CQHB4QJ"; };
      "thinkpad" = { id = "4Z7BDDH-BQCU2WL-S2H3APJ-2S5MVLQ-PZU2SOB-7OJQRSC-AUMQLSI-UHXLOAM"; };
      "MI 9" = { id = "VZ6WQZ4-IPLJA7R-OYNX4KB-WIHB256-NU5LLV5-IM2NPTV-DFC5UZG-VWWLLQK"; };
      "macbook" = { id = "IW3YYMX-AWOW265-73IQGYI-BZZUU52-CLKBKOT-B4JEDZQ-S6J7JQ4-PGL5RAJ"; };
      "nyx" = { id = "QRZ3IRB-PDIR7XZ-VCEFIZQ-QF5O32O-OEVZJIC-BHOVXTL-WQGRFXH-XIVFKAK"; };
    };

    folders = {
      "Keepass" = {
        id = "jgmne-sxjvp";
        path = "/home/borgoat/Keepass";
	devices = [ "tower" "thinkpad" "MI 9" "macbook" ];
	versioning = {
	  type = "simple";
	  params.keep = "10";
	};
      };

      "Syncthing" = {
        id = "yi9hu-m36kc";
	path = "/home/borgoat/Documents/Syncthing";
	devices = [ "tower" "thinkpad" "MI 9" "macbook" ];
	versioning = {
	  type = "simple";
	  params.keep = "10";
	};
      };
    };
  };

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      22000  # Syncthing
    ];

    allowedUDPPorts = [
      22000  # Syncthing
    ];
  };

  services.tailscale.enable = true;

  virtualisation = {
    libvirtd.enable = true;

    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    fira-code
    fira-code-symbols
    jetbrains-mono
    meslo-lgs-nf
  ];

}

