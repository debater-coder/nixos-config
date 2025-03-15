{ lib, pkgs, config, ... }:
with lib;
  let cfg = config.myNixOS.stylix;
in {
  options.myNixOS.stylix = {
    enable = mkEnableOption "my stylix config";
    wallpaper = mkOption {
      type = types.path;
      example = path/to/image;
      description = "Path to wallpaper";
    };
  };

  config = mkIf cfg.enable {
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
      cursor.size = 24;

      fonts = {
        monospace = {
           package = pkgs.jetbrains-mono;
           name = "JetBrainsMono";
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
      image = cfg.wallpaper;
      opacity = {
        terminal = 0.8;
        desktop = 0.5;
      };
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      rubik
      noto-fonts
    ];

    environment.systemPackages = with pkgs; [
      nerd-fonts.jetbrains-mono
      corefonts
    ];
  };
}
