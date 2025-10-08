{lib, config, ...}:
with lib;
let cfg = config.myHomeManager.desktop; in {
  options.myHomeManager.desktop = {
    enable = mkEnableOption "Enable desktop hyprland configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      settings = {
        windowrule = ["center, class:jetbrains-idea"];
        cursor.hide_on_key_press = false;
        monitor = [
          "eDP-1, preferred, 0x0, 1.6"  # laptop screen
          "desc:Dell Inc. DELL S2721QS DV61N43, 3840x2160@60.00Hz, 1600x0, 1.6"  # monitor left
          "desc:Dell Inc. DELL S2721QS 5971N43, 3840x2160@60.00Hz, 4000x0, 1.6"  # monitor right
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
         	"$mod_s, C, exec, hyprpicker -a"
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

    programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            modules-right = [ "tray" "idle_inhibitor" "cpu" "memory" "pulseaudio" "network" "battery" "clock" "custom/notification"];
            modules-center = [ "hyprland/window" ];
            modules-left = [ "hyprland/workspaces" ];
            "idle_inhibitor"= {
                format = "{icon}";
                format-icons = {
                    activated = "";
                    deactivated = "";
                };
            };
            "custom/notification" = {
              tooltip = false;
              format = "{} {icon}";
              "format-icons" = {
                notification = "󱅫";
                none = "";
                "dnd-notification" = " ";
                "dnd-none" = "󰂛";
                "inhibited-notification" = " ";
                "inhibited-none" = "";
                "dnd-inhibited-notification" = " ";
                "dnd-inhibited-none" = " ";
              };
              "return-type" = "json";
              "exec-if" = "which swaync-client";
              exec = "swaync-client -swb";
              "on-click" = "sleep 0.1 && swaync-client -t -sw";
              "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
              escape = true;
            };

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

         #clock {
             min-width:  200px;
         }

         #battery {
          padding: 0 10px;
         }
         @keyframes blink
         {
           to
           {
             background-color: #${config.stylix.base16Scheme.base08};
           }
         }

         #battery.critical:not(.charging)
         {
           animation-name            : blink;
           animation-duration        : 1s;
           animation-timing-function : linear;
           animation-iteration-count : infinite;
           animation-direction       : alternate;
         }
        '';
      };
  };
}
