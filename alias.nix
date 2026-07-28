{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # nixos
    rebuild = "sudo nixos-rebuild switch";
    

    # config files
    networking_config = "sudo nvim ~/nixos-server/networking.nix";
    alias_config = "sudo nvim ~/nixos-server/alias.nix";
    config = "sudo nvim ~/nixos-server/configuration.nix";
    
    minecraft_config = "sudo nvim ~/nixos-server/minecraft.nix";
    minecraft_backup_config = "sudo nvim ~/nixos-server/minecraft-backup.nix";

    # minecraft
    minecraft_console = "sudo podman exec -it minecraft-server rcon-cli";
    minecraft_backup = "sudo systemctl start --no-block minecraft-backup.service";
    minecraft_backup_status = "sudo journalctl -u minecraft-backup.service -f";

  };
}
