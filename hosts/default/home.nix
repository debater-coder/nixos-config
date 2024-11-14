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
    ".config/hyprlock.conf".text = ''
      general {
  no_fade_in = true
  grace = 1
  disable_loading_bar = false
  hide_cursor = true
  ignore_empty_input = true
  text_trim = true
}

#BACKGROUND
background {
    monitor = 
#    path = ~/wallpaper.png
    path = screenshot
    blur_passes = 2
    contrast = 0.8916
    brightness = 0.7172
    vibrancy = 0.1696
    vibrancy_darkness = 0
}

# TIME HR
label {
    monitor =
    text = cmd[update:1000] echo -e "$(date +"%H")"
    color = rgba(255, 255, 255, 1)
    shadow_pass = 2
    shadow_size = 3
    shadow_color = rgb(0,0,0)
    shadow_boost = 1.2
    font_size = 150
#    font_family = JetBrains Mono Nerd Font Mono ExtraBold
    font_family = AlfaSlabOne 
    position = 0, -250
    halign = center
    valign = top
}

# TIME
label {
    monitor =
    text = cmd[update:1000] echo -e "$(date +"%M")"
#    color = 0xff$color0
    color = rgba(255, 255, 255, 1)
    font_size = 150
#    font_family = JetBrains Mono Nerd Font Mono ExtraBold
    font_family = AlfaSlabOne
    position = 0, -420
    halign = center
    valign = top
}

# DATE
label {
    monitor =
    text = cmd[update:1000] echo -e "$(date +"%d %b %A")"
    color = rgba(255, 255, 255, 1)
    font_size = 14
    font_family = JetBrains Mono Nerd Font Mono ExtraBold
    position = 0, -130
    halign = center
    valign = center
}

# LOCATION & WEATHER 
label {
    monitor =
    text = cmd[update:1000] echo "$(bash ~/.config/hypr/bin/location.sh) $(bash ~/.config/hypr/bin/weather.sh)"
    color = rgba(255, 255, 255, 1)
    font_size = 10
    font_family = JetBrains Mono Nerd Font Mono ExtraBold
    position = 0, 465
    halign = center
    valign = center
}


# Music
image {
    monitor =
    path = 
    size = 60 # lesser side if not 1:1 ratio
    rounding = 5 # negative values mean circle
    border_size = 0
    rotate = 0 # degrees, counter-clockwise
    reload_time = 2
    reload_cmd = ~/.config/hypr/bin/playerctlock.sh --arturl
    position = -150, -300
    halign = center
    valign = center
    opacity=0.5
}

# INPUT FIELD
input-field {
    monitor =
    size = 250, 60
    outline_thickness = 0
    outer_color = rgba(0, 0, 0, 1)
    dots_size = 0.1 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 1 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    inner_color = rgba(0, 0, 0, 1)
    font_color = rgba(200, 200, 200, 1)
    fade_on_empty = false
    font_family = JetBrains Mono Nerd Font Mono
    placeholder_text = <span foreground="##cdd6f4"> $USER</span>
    hide_input = false
    position = 0, -470
    halign = center
    valign = center
    zindex = 10
}
# Information
label {
    monitor =
    text = cmd[update:1000] echo -e "$(~/.config/hypr/bin/infonlock.sh)"
    color = rgba(255, 255, 255, 1)
    font_size = 12
    font_family = JetBrains Mono Nerd Font Mono ExtraBold
    position = -20, -510
    halign = right
    valign = center
}
    '';
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
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
      "$mod" = "SUPER";
      "$mod_s" = "SUPER_SHIFT";
      "$mod_c" = "SUPER_CTRL";
      misc = {
        disable_hyprland_logo = true;
	disable_splash_rendering = true;
      };
      bind = [
        "$mod, RETURN, exec, kitty"
	"$mod, M, movefocus, l"
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
	"$mod, mouse:272, movewindow"
	"$mod_c, H, resizeactive, -10 0"
	"$mod_c, J, resizeactive, 0 10"
	"$mod_c, K, resizeactive, 0 -10"
	"$mod_c, L, resizeactive, 10 0"
	"$mod, mouse:273, resizewindow"
      ];
    };
  };

}
