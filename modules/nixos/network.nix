{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.myNixOS.network;
in {
  options.myNixOS.network = {
    enable = mkEnableOption "my network config";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.timeServers = options.networking.timeServers.default ++ [ "0.au.pool.ntp.org" ];
    services.ntp.enable = true;
  };
}
