{ config, pkgs, ... }:

{
  users.groups.media = {};

  users.users.hcg_leo.extraGroups = [ "media" ];
  
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.radarr.extraGroups = [ "media" ];
  users.users.sonarr.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];
  

  systemd.tmpfiles.rules = [
    "d /mnt/storage/movies 0775 root media -"
    "d /mnt/storage/music 0775 root media -"
    "d /mnt/storage/shows 0775 root media -"
  ];

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

  # radarr - movies
  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  # sonarr - shows
  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

  # seerr
  services.seerr = {
    enable = true;
    openFirewall = true;
  };

  # qbittorrent - download client
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    webuiPort = 8080;
  };

  # prowlarr - indexer
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
