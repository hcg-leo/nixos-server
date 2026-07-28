{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rclone ];

  systemd.services.minecraft-backup = {
    description = "backup minecraft server to google drive via rclone";
    
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      
      # using 'sync' makes the destination exactly match the source. 
      # if you prefer to only add files and never delete, change 'sync' to 'copy'
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone sync /var/lib/minecraft gdrive:MinecraftServerBackup \
          --config /root/secrets/rclone.conf \
          --verbose
      '';
    };
  };

  systemd.timers.minecraft-backup = {
    description = "timer for minecraft server backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
  };
}
