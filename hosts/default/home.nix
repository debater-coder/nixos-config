{ config, pkgs, ... }:

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
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };


  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.waybar = {
    enable = true;
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixos#default";
    };
  };

  programs.git = {
    enable = true;
    userName = "debater-coder";
    userEmail = "52619668+debater-coder@users.noreply.github.com";
  };

  programs.neovim = {
    enable = true;
    extraConfig = '' 
      set number relativenumber expandtab autoindent
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      cursor.hide_on_key_press = false;
      monitor = [
        "eDP-1, preferred, 0x0, 1.6"  # laptop screen
        "desc:Dell Inc. DELL S2721QS DV61N43, preferred, auto-right, 1.5"  # monitor left
        "desc:Dell Inc. DELL S2721QS 5971N43, preferred, auto-right, 1.5"  # monitor right
        ", preferred, auto, 1"  # random monitors
      ];
      "$mod" = "SUPER";
      "$mod_s" = "SUPER_SHIFT";
      "$mod_c" = "SUPER_CTRL";
      misc = {
        disable_hyprland_logo = true;
	disable_splash_rendering = true;
      };
      decoration = {
        rounding = 8;
        inactive_opacity = 0.75;
      };
      bind = [
        "$mod, RETURN, exec, kitty"
	"$mod, H, movefocus, l"
	"$mod, J, movefocus, d"
	"$mod, k, movefocus, u"
	"$mod, l, movefocus, r"
	"$mod, Q, killactive"
	"$mod, F, fullscreen"
	"$mod, T, togglefloating"
	"$mod_s, H, movewindow, l"
	"$mod_s, J, movewindow, d"
	"$mod_s, K, movewindow, u"
	"$mod_s, L, movewindow, r"
	"$mod_c, H, resizeactive, -10 0"
	"$mod_c, J, resizeactive, 0 10"
	"$mod_c, K, resizeactive, 0 -10"
	"$mod_c, L, resizeactive, 10 0"
        "$mod, DELETE, exec, swaylock -u"
        ''
        ALT, SPACE, exec, rofi -show combi -modes combi -combi-modes "window,drun,run"
        ''
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );

      bindm = [
	"$mod, mouse:273, resizewindow"
	"$mod, mouse:272, movewindow"
      ];
      bindl = [
        ''
          , switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"
        ''
        ''
          , switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, 0x0, 1.6"
        ''
      ];
      exec-once = [
        "waybar"
      ];
      input.touchpad = {
        natural_scroll = true;
        scroll_factor = 0.2;
      };

      cursor = {
        no_hardware_cursors = true;
      };
    };
  };
}
