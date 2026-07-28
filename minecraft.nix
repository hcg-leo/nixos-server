{ config, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.minecraft-server = {
      image = "itzg/minecraft-server";
      autoStart = true;
      ports = [ 
        "25565:25565/tcp" 
        "24454:24454/udp"
      ];
      environment = {
        EULA = "true";
        TYPE = "PAPER";
        MEMORY = "6G";
        VERSION = "26.1.2";
      };
      volumes = [
        "/var/lib/minecraft:/data"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 24454 ];

  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft 0755 1000 1000 -"
  ];
}
