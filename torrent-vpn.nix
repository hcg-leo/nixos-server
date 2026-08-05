{ config, pkgs, ... }: 

{
  vpnNamespaces.mullvad = {
    enable = true;
    wireguardConfigFile = "/root/secrets/mullvad.conf"; 
    portMappings = [
      { from = 8080; to = 8080; }
    ];
  };

  systemd.services.qbittorrent.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };
}
