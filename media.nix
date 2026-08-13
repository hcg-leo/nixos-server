{ config, pkgs, ... }:

{
  users.groups.media = {};

  users.users.hcg_leo.extraGroups = [ "media" ];
  
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];
  

  systemd.tmpfiles.rules = [
    "d /mnt/storage/movies 2775 root media -"
    "d /mnt/storage/music 2775 root media -"
    "d /mnt/storage/shows 2775 root media -"
    "d /mnt/storage/downloads 2775 root media -"
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

  # qbittorrent - download client
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    webuiPort = 8080;
  };

}
