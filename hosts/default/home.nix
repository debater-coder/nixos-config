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

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.waybar.enable = false;
  programs.kitty.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-right = [ "tray" "cpu" "memory" "pulseaudio" "network" "battery" "clock" ];
        modules-center = [ "hyprland/window" ];
        modules-left = [ "hyprland/workspaces" ];

        clock = {
          interval = 1;
          format = "{:%r %d/%m/%Y}";
        };

        "hyprland/window" = {
          separate-outputs = true;
        };

        "hyprland/workspaces" = {
          persistent-workspaces = {
            "*" = 3;
          };
        };

        cpu.format = "CPU {usage}%";
        memory.format = "MEM {}%";

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        network = {
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ipaddr}/{cidr}";
          format-disconnected = "";
        };

        battery = {
          format = "{capacity}% {icon}";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          interval = 5;
          states = {
            warning = 30;
            critical = 10;
          };
          tooltip = false;
        };
      };
    };
    style = ''
      * {
        border: none;
        font-family: "Rubik", "JetBrainsMono Nerd Font", Helvetica, Arial, sans-serif;
        font-size: 14px;
        min-height: 0;
        background: none;
        color: @theme_text_color;
      }

      #waybar {
        background: @theme_bg_color;
      }

      #tray menu {
        background: @theme_bg_color;
      }

      .module {
        margin: 0 10px 0;
      }


     #workspaces button:hover {
       background-color: shade(@theme_bg_color, 1.8);
     }

     #workspaces button.visible {
        background-color: shade(#${config.stylix.base16Scheme.base0D}, 0.8);
     }

     #workspaces button.visible:hover {
        background-color: #${config.stylix.base16Scheme.base0D};
     }
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixos#default";
      test-update = "sudo nixos-rebuild test --flake ~/nixos#default";
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
      set sw=2
    '';
  };

  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
    };

    listener = [
      {
        timeout = 120;
        on-timeout = "brightnessctl -s set 10%";
        on-resume = "brightnessctl -r";
      }
      {
        timeout = 150;
        on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
      }

      {
        timeout = 180;
        on-timeout = "hyprctl dispatch dpms off";        # screen off when timeout has passed
        on-resume = "hyprctl dispatch dpms on";          # screen on when activity is detected after timeout has fired.
      }

      {
        timeout = 1800;                                # 30min
        on-timeout = "systemctl suspend";                # suspend pc
      }
    ];
  };

  programs.hyprlock = {
    enable = true;
    settings.background.path = lib.mkForce "";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      cursor.hide_on_key_press = false;
      monitor = [
        "eDP-1, preferred, 0x0, 1.6"  # laptop screen
        "desc:Dell Inc. DELL S2721QS DV61N43, preferred, 1600x0, 1.5"  # monitor left
        "desc:Dell Inc. DELL S2721QS 5971N43, preferred, 4160x0, 1.5"  # monitor right
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
        ''
        $mod_s, S, exec, grim -g "$(slurp -d)" - | wl-copy
	''
        "$mod_c, H, resizeactive, -10 0"
	"$mod_c, J, resizeactive, 0 10"
	"$mod_c, K, resizeactive, 0 -10"
	"$mod_c, L, resizeactive, 10 0"
        "$mod, DELETE, exec, hyprlock"
        ''
        ALT, SPACE, exec, walker
        ''
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, focusworkspaceoncurrentmonitor, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
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
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      exec-once = [
        "hypridle"
        "nm-applet"
        "udiskie"
        "blueman-applet"
        "waybar"
        "hyprpaper"
      ];
      input.touchpad = {
        natural_scroll = true;
        scroll_factor = 0.2;
      };

      cursor = {
        no_hardware_cursors = true;
      };
      xwayland.force_zero_scaling = true;
      gestures.workspace_swipe = true;
      gestures.workspace_swipe_forever = true;
    };
  };
}
