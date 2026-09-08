{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.ogd-server = {
    image = "richardxregistry/ogd-server:latest";
    autoStart = true;

    ports = [
      "3005:3005"
    ];

    # CLIENT_SECRET is the only env var the upstream docker-compose.yml
    # declares. Put it in /root/secrets/ogd.env as a single line:
    #   CLIENT_SECRET=your-google-oauth-client-secret
    environmentFiles = [
      "/root/secrets/ogd.env"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 3005 ];
}
