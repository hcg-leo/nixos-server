{ config, pkgs, ... }:

{
  # --- Docker backend for oci-containers ---
  # Not currently enabled anywhere in your nixos-server repo, so it's added here.
  # If you already enable virtualisation.docker elsewhere, remove this line
  # (NixOS will error on a duplicate `enable = true` set from two modules
  # only if they conflict; harmless duplicate `true` values just merge, but
  # keep it in one place for clarity).
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.ogd-server = {
    image = "richardxregistry/ogd-server:latest";
    autoStart = true;

    # Container listens on 3005 (confirmed in upstream docker-compose.yml).
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

  # Exposes the server on the LAN at http://<server-ip>:3005
  # Drop this (or restrict it) if you don't want it reachable from outside
  # localhost, e.g. if you plan to put it behind a reverse proxy instead.
  networking.firewall.allowedTCPPorts = [ 3005 ];
}

