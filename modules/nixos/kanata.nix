{ lib, config, pkgs, ... }:
with lib;
let cfg = config.myNixOS.kanata; in {
  options.myNixOS.kanata = {
    enable = mkEnableOption "Kanata configuration";
  };

  config = mkIf cfg.enable {
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
    environment.systemPackages = [
      pkgs.kanata
    ];
  };
}
