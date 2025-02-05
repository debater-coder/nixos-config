{ pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/common.nix
      ../../modules/nixos/kanata.nix
      ../../modules/nixos/hardware.nix
      ../../modules/nixos/network.nix
      ../../modules/nixos/stylix.nix
      inputs.home-manager.nixosModules.default
    ];

  boot = {
    plymouth = {
      enable = true;
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "starscream";

  myNixOS = {
    kanata.enable = true;
    hardware.allowUserTTYAccess = true;
    network.enable = true;
    stylix = {
      enable = true;
      wallpaper = ./home/wallpaper.jpg;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hamzah = {
    isNormalUser = true;
    description = "Hamzah";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = [];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.direnv.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "hamzah" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    kitty
    hyprpaper
    git
    gh
    waybar
    libnotify
    rofi-wayland
    xwayland
    swaylock
    bibata-cursors
    gnome-themes-extra
    hypridle
    hyprlock
    firefoxpwa
    prusa-slicer
    base16-schemes
    discord
    grim
    slurp
    wl-clipboard
    nautilus
    chromium
    pavucontrol
    networkmanagerapplet
    gnome-calculator
    gnome-clocks
    gnome-disk-utility
    gnome-connections
    snapshot
    gnome-font-viewer
    loupe
    gnomeExtensions.system-monitor
    gnome-text-editor
    totem
    gnome-weather
    apostrophe
    binary
    commit
    gnome-graphs
    impression
    gnome-boxes
    vscode
    gtk4-layer-shell
    telegram-desktop
    walker
    gnome-keyring
    pkg-config
    udiskie
    inputs.zen-browser.packages."${system}".default
    nodejs_22
    pnpm
    picocom
    brightnessctl
    probe-rs-tools
    jetbrains.datagrip
    zed-editor
    nixd
    nil
    rust-analyzer
    rshell
    swaynotificationcenter
    onedriver
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs.waybar.enable = true;

  programs.neovim.defaultEditor = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.hyprlock.enable = true;
  programs.thunderbird.enable = true;

  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      binPath = "/run/current-system/sw/bin/Hyprland";
      comment = "Hyprland session managed by uwsm";
      prettyName = "Hyprland";
    };
  };

  services.ollama.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
