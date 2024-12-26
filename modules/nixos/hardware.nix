{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.myNixOS.hardware;
in {
  options.myNixOS.hardware = {
    allowUserTTYAccess = mkEnableOption "users to read and write to TTY ports";
  };

  config = {
    services.udev.extraRules = mkIf cfg.allowUserTTYAccess ''
      KERNEL=="ttyUSB[0-9]*",MODE="0666"
      KERNEL=="ttyACM[0-9]*",MODE="0666"
    '';

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

    services.logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';
  };
}
