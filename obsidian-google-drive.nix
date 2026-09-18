{ config, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.ogd-server = {
      image = "docker.io/richardxregistry/ogd-server:latest";
      autoStart = true;

      # bound to loopback only - nginx is the only thing that talks to it
      ports = [ "127.0.0.1:3005:3005" ];

      environmentFiles = [ "/root/secrets/ogd-server.env" ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "CHANGE-ME@example.com";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."hcg-leo.duckdns.org" = {
      enableACME = true;
      forceSSL = true;

      locations."/api/access" = {
        proxyPass = "http://127.0.0.1:3005";
      };

      # everything else gets nothing
      locations."/" = {
        return = "404";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
