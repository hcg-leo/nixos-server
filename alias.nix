{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # nixos
    rebuild = "sudo nixos-rebuild switch";
    

    # config
    networking-config = "sudo nvim ~/nixos-server/networking.nix";
    alias-config = "sudo nvim ~/nixos-server/alias.nix";
    config = "sudo nvim ~/nixos-server/configuration.nix";
    
    # minecraft
    minecraft-config = "sudo nvim ~/nixos-server/minecraft.nix";
    minecraft-backup-config = "sudo nvim ~/nixos-server/minecraft-backup.nix";
    minecraft-console = "sudo podman exec -it minecraft-server rcon-cli";
    minecraft-console_logs = "sudo journalctl -fu podman-minecraft-server.service";
    minecraft-backup = "sudo systemctl start --no-block minecraft-backup.service";
    minecraft-backup-logs = "sudo journalctl -u minecraft-backup.service -f";
    minecraft-stop = "sudo podman stop -t 60 minecraft-server";

    # media
    media-config = "sudo nvim ~/nixos-server/media.nix";

    # vpn torrent
    mullvad = "sudo ip netns exec qbtns curl -s ifconfig.me";
    vpn-torrent = "sudo nvim ~/nixos-server/vpn-torrent.nix";

    # other
    reboot = "sudo reboot";
    timers = "sudo systemctl list-timers --all";
    pub-ip = "curl -4 ifconfig.me";
  };
}
