{ config, pkgs, ... }:

{
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
    "d /mnt/storage/movies 0775 jellyfin jellyfin -"
    "d /mnt/storage/music  0775 jellyfin jellyfin -"
  ];

  users.users.hcg_leo.extraGroups = [ "jellyfin" ];
}
