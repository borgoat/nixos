# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Graphical boot screen
  boot.plymouth.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Keyboards
    layout = "us,it";
  };

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    android-studio
    ckan
    firefox
    gimp
    gnome3.gnome-tweaks
    gnomeExtensions.espresso
    inkscape
    jetbrains.clion
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.webstorm
    keepassxc
    libreoffice-fresh
    lutris
    scribus
    signal-desktop
    teams
    zoom-us
  ];

  fonts = {
    fonts = with pkgs; [
      corefonts
      fira-code
      fira-code-symbols
      jetbrains-mono
      meslo-lgs-nf
      noto-fonts
    ];

    fontDir.enable = true;
  };

}

