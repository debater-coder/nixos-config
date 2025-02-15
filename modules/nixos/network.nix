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
    networking.timeServers = options.networking.timeServers.default ++ [ "au.pool.ntp.org" ];
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

  };
}
