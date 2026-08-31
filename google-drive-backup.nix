{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rclone ];

  systemd.services.google-drive-backup = {
    description = "mirror google drive to local storage via rclone";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";

      ExecStart = ''
        ${pkgs.rclone}/bin/rclone sync gdrive: /mnt/storage/google-drive-backup \
          --config /root/secrets/rclone.conf \
          --drive-export-formats docx,xlsx,pptx,svg \
          --verbose
      '';
    };
  };

  systemd.timers.google-drive-backup = {
    description = "timer for google drive backup";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
  };
}
