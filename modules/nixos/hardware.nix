{ lib, config, ... }:
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

    services.pulseaudio.enable = true;
    services.pipewire = {
        enable = true;
        audio.enable = false;
        pulse.enable = false;
        alsa.enable = false;
        wireplumber.enable = true;
      };
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

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
    };
  };
}
