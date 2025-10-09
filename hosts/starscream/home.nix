{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hamzah";
  home.homeDirectory = "/home/hamzah";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    rustup
    gcc
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  ".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFx4HxNcoOgY8yfFhg2cjhSxeGKTf4TzIighHKWWHumP hamzah@syedahmed.net";
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hamzah/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    WLR_NO_HARDWARE_CURSORS = "1";
    GOROOT = "/usr/local/go";
    GOPATH = "$HOME/go";
  };
  home.sessionPath = [
    "$GOPATH/bin"
    "$GOROOT/bin"
    "$HOME/.local/bin"
  ];

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.waybar.enable = false;
  programs.kitty.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  myHomeManager = {
    shell.enable = true;
    desktop.enable = false;
    direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "debater-coder";
    userEmail = "hamzah@syedahmed.net";
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber expandtab autoindent
      set sw=2
    '';
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
    };
  };
}
