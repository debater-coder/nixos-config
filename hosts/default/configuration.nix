# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "starscream"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable networking
  networking.networkmanager.enable = true;
  ## To use, put this in your configuration, switch to it, and restart NM:
  ## $ sudo systemctl restart NetworkManager.service
  ## To check if it works, you can do `sudo systemctl status systemd-timesyncd.service`
  ## (it may take a bit of time to pick the right NTP as it may try the
  ## other NTP firsts)
  networking.networkmanager.dispatcherScripts = [
    {
      # https://wiki.archlinux.org/title/NetworkManager#Dynamically_set_NTP_servers_received_via_DHCP_with_systemd-timesyncd
      # You can debug with sudo journalctl -u NetworkManager-dispatcher -e
      # make sure to restart NM as described above
      source = pkgs.writeText "10-update-timesyncd" ''
        [ -z "$CONNECTION_UUID" ] && exit 0
        INTERFACE="$1"
        ACTION="$2"
        case $ACTION in
        up | dhcp4-change | dhcp6-change)
            systemctl restart systemd-timesyncd.service
            if [ -n "$DHCP4_NTP_SERVERS" ]; then
              echo "Will add the ntp server $DHCP4_NTP_SERVERS"
            else
              echo "No DHCP4 NTP available."
              exit 0
            fi
            mkdir -p /etc/systemd/timesyncd.conf.d
            # <<-EOF must really use tabs to keep indentation correct… and tabs are often converted to space in wiki
            # so I don't want to risk strange issues with indentation
            echo "[Time]" > "/etc/systemd/timesyncd.conf.d/''${CONNECTION_UUID}.conf"
            echo "NTP=$DHCP4_NTP_SERVERS" >> "/etc/systemd/timesyncd.conf.d/''${CONNECTION_UUID}.conf"
            systemctl restart systemd-timesyncd.service
            ;;
        down)
            rm -f "/etc/systemd/timesyncd.conf.d/''${CONNECTION_UUID}.conf"
            systemctl restart systemd-timesyncd.service
            ;;
        esac
        echo 'Done!'
      '';
    }
  ];

  # Set your time zone.
  time.timeZone = "Australia/Sydney";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hamzah = {
    isNormalUser = true;
    description = "Hamzah";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "hamzah" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.onedrive.enable = true;

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
    mako
    libnotify
    rofi-wayland
    xwayland
    swaylock
    bibata-cursors
    gnome-themes-extra
    hyprlock
    kanata
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
    corefonts
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
    nerd-fonts.jetbrains-mono
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs.waybar.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    rubik
    noto-fonts
  ];

  programs.neovim.defaultEditor = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           caps a s d f j k l ;
          )
          (defvar
           tap-time 300
           hold-time 500
          )
          (defalias
           caps esc
           a (tap-hold-release-timeout $tap-time $hold-time a lmet a)
           s (tap-hold-release-timeout $tap-time $hold-time s lalt s)
           d (tap-hold-release-timeout $tap-time $hold-time d lsft d)
           f (tap-hold-release-timeout $tap-time $hold-time f lctl f)
           j (tap-hold-release-timeout $tap-time $hold-time j rctl j)
           k (tap-hold-release-timeout $tap-time $hold-time k rsft k)
           l (tap-hold-release-timeout $tap-time $hold-time l ralt l)
           ; (tap-hold-release-timeout $tap-time $hold-time ; rmet ;)
          )

          (deflayer base
           @caps @a  @s  @d  @f  @j  @k  @l  @;
          )
        '';
      };
    };
  };

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

  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      binPath = "/run/current-system/sw/bin/Hyprland";
      comment = "Hyprland session managed by uwsm";
      prettyName = "Hyprland";
    };
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  stylix = {
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
    base16Scheme = {
      base00 = "212121";
      base01 = "303030";
      base02 = "353535";
      base03 = "4A4A4A";
      base04 = "B2CCD6";
      base05 = "EEFFFF";
      base06 = "EEFFFF";
      base07 = "FFFFFF";
      base08 = "F07178";
      base09 = "F78C6C";
      base0A = "FFCB6B";
      base0B = "C3E88D";
      base0C = "89DDFF";
      base0D = "82AAFF";
      base0E = "C792EA";
      base0F = "FF5370";
    };
    enable = true;
    autoEnable = true;
    
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Classic";
   
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.rubik;
        name = "Rubik";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
    };
    image = ./home/wallpaper.png;
    opacity = {
      terminal = 0.8;
      desktop = 0.5;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
