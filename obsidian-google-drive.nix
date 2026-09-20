{ config, pkgs, ... }:

{
  # secret file: /root/secrets/ogd-server.env
  #   CLIENT_SECRET=GOCSPX-yourclientsecret

  virtualisation.podman.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.ogd-server = {
      image = "docker.io/richardxregistry/ogd-server:latest";
      autoStart = true;
      ports = [ "127.0.0.1:3005:3005" ];
      environmentFiles = [ "/root/secrets/ogd-server.env" ];
    };
  };

  services.caddy = {
    enable = true;
    email = "CHANGE-ME@example.com";
    virtualHosts."hcg-leo.duckdns.org".extraConfig = ''
      reverse_proxy 127.0.0.1:3005
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
