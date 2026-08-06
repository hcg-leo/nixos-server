{ config, pkgs, ... }: 

{
  vpnNamespaces.mullvad = {
    enable = true;
    wireguardConfigFile = "/root/secrets/mullvad.conf"; 
    
    accessibleFrom = [ 
      "192.168.1.0/24" # for sonarr/radarr config, enter 192.168.15.1
    ];
    
    portMappings = [
      { from = 8080; to = 8080; }
    ];
  };

  systemd.services.qbittorrent.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };
  
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
