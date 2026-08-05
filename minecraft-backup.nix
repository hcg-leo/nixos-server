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
      
      ExecStartPre = "${pkgs.systemd}/bin/systemctl stop podman-minecraft-server.service";
      
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone sync /var/lib/minecraft gdrive:backup/nixos-server-files/minecraft-server-backup \
          --config /root/secrets/rclone.conf \
          --verbose
      '';

      ExecStopPost = "${pkgs.systemd}/bin/systemctl start podman-minecraft-server.service";
    };
  };

  systemd.timers.minecraft-backup = {
    description = "timer for minecraft server backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 21:00:00";
      Persistent = true;
    };
  };
}
