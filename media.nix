{ config, pkgs, ... }:

{
  # jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true; 
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  systemd.tmpfiles.rules = [
    # general libraries
    "d /mnt/storage/movies 0775 jellyfin jellyfin -"
    "d /mnt/storage/music 0775 jellyfin jellyfin -"
    "d /mnt/storage/shows 0775 jellyfin jellyfin -"
  ];

  users.users.hcg_leo.extraGroups = [ "jellyfin" "radarr" "sonarr" ];

  # radarr - movies
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "jellyfin";
  };

  # sonarr - shows
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "jellyfin";
  };

  # seerr
  services.seerr = {
    enable = true;
    openFirewall = true;
  };

  # qbittorrent - download client
  services.qbittorrent = {
    enable = true;
    group = "jellyfin";
    openFirewall = true;
    webuiPort = 8080;
  };

  # prowlarr - indexer
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
