{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "borgoat";
  home.homeDirectory = "/home/borgoat";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    android-tools
    android-studio
    erlang
    elixir
    gnomeExtensions.espresso
    gnomeExtensions.gsconnect
    gopass
    keepassxc
    jetbrains.clion
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.webstorm
    signal-desktop
    zoom-us
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Command-line JSON processor
  programs.jq.enable = true;

  # When firefox won't work
  programs.chromium = {
    enable = true;
    # TODO Extensions
  };

  programs.git = {
    enable = true;
    userName = "Giorgio Azzinnaro";
    userEmail = "giorgio@azzinna.ro";

    includes = [
      {
        condition = "gitdir:~/Workspace/*/yeekatee/";
        contents = {
          user = {
            email = "giorgio.azzinnaro@yeekatee.com";
          };

          core = {
            sshCommand = "ssh -i ~/.ssh/id_ed25519-yeekatee";
          };
        };
      }
    ];
  };

  # TODO Understand how to manage extensions: https://nixos.wiki/wiki/Visual_Studio_Code
  programs.vscode.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
  };

  programs.zsh = {
    enable = true;

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };

    plugins = [
      {
        name = "powerlevel10k-config";
        src = pkgs.lib.cleanSource ./zsh;
        file = "p10k.zsh";
      }
    ];
  };

  programs.zoxide.enable = true;

}

