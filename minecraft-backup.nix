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
      
      # 1. Stop the Podman Minecraft server before starting the backup
      ExecStartPre = "${pkgs.systemd}/bin/systemctl stop podman-minecraft-server.service";
      
      # 2. Run the backup (using 'sync' to match source to destination exactly)
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone sync /var/lib/minecraft gdrive:MinecraftServerBackup \
          --config /root/secrets/rclone.conf \
          --verbose
      '';

      # 3. Start the Podman Minecraft server again after the backup completes (or if it fails)
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
