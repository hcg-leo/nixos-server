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

    # aran thananjayans libraries
    "d /mnt/storage/aran_thananjayan_movies 0775 jellyfin jellyfin -"
    "d /mnt/storage/aran_thananjayan_music 0775 jellyfin jellyfin -"
    "d /mnt/storage/aran_thananjayan_shows 0775 jellyfin jellyfin -"
  ];

  users.users.hcg_leo.extraGroups = [ "jellyfin" "radarr" "sonarr" ];

  # radarr
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "jellyfin";
  };

  # sonarr
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
}
