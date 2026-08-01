{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # nixos
    rebuild = "sudo nixos-rebuild switch";
    

    # config files
    networking-config = "sudo nvim ~/nixos-server/networking.nix";
    alias-config = "sudo nvim ~/nixos-server/alias.nix";
    config = "sudo nvim ~/nixos-server/configuration.nix";
    
    minecraft-config = "sudo nvim ~/nixos-server/minecraft.nix";
    minecraft-backup_config = "sudo nvim ~/nixos-server/minecraft-backup.nix";

    media-config = "sudo nvim ~/nixos-server/jellyfin.nix";

    # minecraft
    minecraft-console = "sudo podman exec -it minecraft-server rcon-cli";
    minecraft-console_logs = "sudo journalctl -fu podman-minecraft-server.service";
    minecraft-backup = "sudo systemctl start --no-block minecraft-backup.service";
    minecraft-backup_logs = "sudo journalctl -u minecraft-backup.service -f";
    minecraft-stop = "sudo podman stop -t 60 minecraft-server";
    
    # other
    reboot = "sudo reboot";
  };
}
