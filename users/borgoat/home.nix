# graphical is our extraSpecialArg that we pass to home-manager, false by default
{
  config,
  pkgs,
  graphical,
  ...
}:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = rec {
    username = "borgoat";
    homeDirectory = "/home/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";
  };

  # Packages that should be installed to the user profile.
  # home.packages = with pkgs; [];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Command-line JSON processor
  programs.jq.enable = true;

  # When firefox won't work
  # programs.chromium = {
  #  enable = true;
  #  # TODO Extensions
  # };

  programs.git = {
    enable = true;
    userName = "Giorgio Azzinnaro";
    userEmail = "giorgio@azzinna.ro";

    difftastic.enable = true;

    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };

  programs.vscode =
    if graphical then
      {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          vscodevim.vim
        ];
      }
    else
      {
        enable = false;
      };

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      # Colorized command output
      {
        name = "git-abbr";
        src = git-abbr.src;
      }
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "tide";
        src = tide.src;
      }
    ];
  };

  # A nice text editor
  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
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
    fuzzySearchFactor = 2;
  };

  # A cross-platform graphical process/system monitor with a customizable interface
  programs.bottom.enable = true;

  programs.direnv.enable = true;

  # programs.go = {
  #   enable = true;
  #   package = pkgs.go_1_18;
  # };

}
