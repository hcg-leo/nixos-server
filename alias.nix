{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # nixos
    rebuild = "sudo nixos-rebuild switch";
    
    # config
    networking = "sudo nvim ~/nixos-server/networking.nix";
    alias = "sudo nvim ~/nixos-server/alias.nix";
    config = "sudo nvim ~/nixos-server/configuration.nix";
    
    # minecraft-console = "sudo podman exec -it minecraft-server rcon-cli";
    # minecraft-console_logs = "sudo journalctl -fu podman-minecraft-server.service";
    # minecraft-stop = "sudo podman stop -t 60 minecraft-server";

    # media
    media = "sudo nvim ~/nixos-server/media.nix";

    # vpn torrent
    mullvad = "sudo ip netns exec qbtns curl -s ifconfig.me";
    vpn-torrent = "sudo nvim ~/nixos-server/vpn-torrent.nix";

    # other
    timers = "sudo systemctl list-timers --all";
    pub-ip = "curl -4 ifconfig.me";
  };
}
