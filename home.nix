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
    duf  # A better df alternative
    du-dust  # A more intuitive version of du in rust
    erlang
    elixir
    file  # A program that shows the type of files
    firefox
    gnomeExtensions.espresso
    gnomeExtensions.gsconnect
    gopass
    hexyl  # A command-line hex viewer
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

    difftastic.enable = true;

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };

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
    sensibleOnTop = true;
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

  # A fast cd command that learns your habits
  programs.zoxide.enable = true;

  # The next gen ls command
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  # A cat(1) clone with syntax highlighting and Git integration
  programs.bat.enable = true;

  # A command-line fuzzy finder written in Go
  programs.fzf.enable = true;

  # An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now
  programs.mcfly = {
    enable = true;
    enableFuzzySearch = true;
  };

  # A cross-platform graphical process/system monitor with a customizable interface
  programs.bottom.enable = true;

}

